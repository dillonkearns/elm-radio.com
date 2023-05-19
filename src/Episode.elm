module Episode exposing (Episode, PublishDate(..), cachedLookup, cachedLookupWithMetadata, episodeRequest, formatDate, request, slugs, toDate, view)

import BackendTask exposing (BackendTask)
import BackendTask.Custom
import BackendTask.Env as Env
import BackendTask.File
import BackendTask.Glob as Glob
import BackendTask.Http
import DateFormat
import FatalError exposing (FatalError)
import Html exposing (..)
import Html.Attributes exposing (..)
import Iso8601
import Json.Decode as Decode exposing (Decoder)
import Json.Encode
import Pages
import Path exposing (Path)
import Route exposing (Route)
import Time


slugs : BackendTask FatalError (List String)
slugs =
    Glob.succeed identity
        |> Glob.match (Glob.literal "content/episode/")
        |> Glob.capture Glob.wildcard
        |> Glob.match (Glob.literal ".md")
        |> Glob.toBackendTask


request : List ( Route, EpisodeData ) -> BackendTask FatalError (List Episode)
request episodes =
    episodes
        |> List.map (\( route, episode ) -> episodeRequest route episode)
        |> BackendTask.combine


cachedLookup : Route -> EpisodeData -> BackendTask FatalError Episode
cachedLookup route episodeData =
    let
        filePath : String
        filePath =
            "simplecast-cache/" ++ String.fromInt episodeData.number ++ ".json"
    in
    Glob.literal filePath
        |> Glob.toBackendTask
        |> BackendTask.andThen
            (\matchingFiles ->
                if matchingFiles |> List.isEmpty then
                    (Env.expect "SIMPLECAST_TOKEN"
                        |> BackendTask.allowFatal
                        |> BackendTask.andThen
                            (\simplecastToken ->
                                BackendTask.Http.getWithOptions
                                    { url = "https://api.simplecast.com/episodes/" ++ episodeData.simplecastId
                                    , headers = [ ( "Authorization", "Bearer " ++ simplecastToken ) ]
                                    , expect =
                                        Decode.map2 Tuple.pair Decode.value (episodeDecoder route episodeData)
                                            |> BackendTask.Http.expectJson
                                    , cachePath = Nothing
                                    , cacheStrategy = Nothing
                                    , retries = Nothing
                                    , timeoutInMs = Nothing
                                    }
                                    |> BackendTask.allowFatal
                            )
                    )
                        |> BackendTask.andThen
                            (\( rawJson, decoded ) ->
                                writeFile
                                    filePath
                                    (Json.Encode.encode 0 rawJson)
                                    |> BackendTask.map (\() -> decoded)
                            )

                else
                    BackendTask.File.jsonFile
                        (episodeDecoder route episodeData)
                        filePath
                        |> BackendTask.allowFatal
            )


episodeDataDecoder : Decoder EpisodeData
episodeDataDecoder =
    Decode.map4 EpisodeData
        (Decode.field "number" Decode.int)
        (Decode.field "title" Decode.string)
        (Decode.field "description" Decode.string)
        (Decode.field "simplecastId" Decode.string)


cachedLookupWithMetadata : String -> BackendTask FatalError Episode
cachedLookupWithMetadata slug =
    ("content/episode/" ++ slug ++ ".md")
        |> BackendTask.File.onlyFrontmatter episodeDataDecoder
        |> BackendTask.allowFatal
        |> BackendTask.andThen
            (\episodeData ->
                let
                    filePath : String
                    filePath =
                        "simplecast-cache/" ++ String.fromInt episodeData.number ++ ".json"

                    route : Route
                    route =
                        Route.Episode__Name_ { name = slug }
                in
                Glob.literal filePath
                    |> Glob.toBackendTask
                    |> BackendTask.allowFatal
                    |> BackendTask.andThen
                        (\matchingFiles ->
                            if matchingFiles |> List.isEmpty then
                                (Env.expect "SIMPLECAST_TOKEN"
                                    |> BackendTask.allowFatal
                                    |> BackendTask.andThen
                                        (\simplecastToken ->
                                            BackendTask.Http.getWithOptions
                                                { url = "https://api.simplecast.com/episodes/" ++ episodeData.simplecastId
                                                , headers = [ ( "Authorization", "Bearer " ++ simplecastToken ) ]
                                                , expect =
                                                    Decode.map2 Tuple.pair Decode.value (episodeDecoder route episodeData)
                                                        |> BackendTask.Http.expectJson
                                                , timeoutInMs = Nothing
                                                , retries = Nothing
                                                , cacheStrategy = Nothing
                                                , cachePath = Nothing
                                                }
                                                |> BackendTask.allowFatal
                                        )
                                )
                                    |> BackendTask.andThen
                                        (\( rawJson, decoded ) ->
                                            writeFile
                                                filePath
                                                (Json.Encode.encode 0 rawJson)
                                                |> BackendTask.map (\() -> decoded)
                                        )

                            else
                                BackendTask.File.jsonFile
                                    (episodeDecoder route episodeData)
                                    filePath
                                    |> BackendTask.allowFatal
                        )
            )


writeFile : String -> String -> BackendTask FatalError ()
writeFile filePath contents =
    BackendTask.Custom.run "writeFile"
        (Json.Encode.object
            [ ( "filePath", Json.Encode.string filePath )
            , ( "contents", contents |> Json.Encode.string )
            ]
        )
        (Decode.succeed ())
        |> BackendTask.allowFatal


episodeRequest : Route -> EpisodeData -> BackendTask FatalError Episode
episodeRequest route episodeData =
    cachedLookup route episodeData


type alias Episode =
    { title : String
    , description : String
    , guid : String
    , route : Route
    , publishAt : PublishDate
    , duration : Int
    , number : Int
    , audio :
        { url : String
        , sizeInBytes : Int
        }
    }


episodeDecoder : Route -> EpisodeData -> Decoder Episode
episodeDecoder route episodeData =
    Decode.map4
        (Episode episodeData.title episodeData.description episodeData.simplecastId route)
        scheduledOrPublishedTime
        (Decode.field "duration" Decode.int)
        (Decode.field "number" Decode.int)
        (Decode.field "audio_file"
            (Decode.map2 (\url sizeInBytes -> { url = url, sizeInBytes = sizeInBytes })
                (Decode.field "url" Decode.string)
                (Decode.field "size" Decode.int)
            )
        )


type PublishDate
    = Scheduled Time.Posix
    | Published Time.Posix


toDate : PublishDate -> Time.Posix
toDate publishDate =
    case publishDate of
        Scheduled time ->
            time

        Published time ->
            time


scheduledOrPublishedTime : Decoder PublishDate
scheduledOrPublishedTime =
    Decode.oneOf
        [ Decode.field "scheduled_for" iso8601Decoder
        , Decode.field "published_at" iso8601Decoder
        ]
        |> Decode.map
            (\time ->
                if Time.posixToMillis time > Time.posixToMillis Pages.builtAt then
                    Scheduled time

                else
                    Published time
            )


iso8601Decoder : Decoder Time.Posix
iso8601Decoder =
    Decode.string
        |> Decode.andThen
            (\datetimeString ->
                case Iso8601.toTime datetimeString of
                    Ok time ->
                        Decode.succeed time

                    Err _ ->
                        Decode.fail "Could not parse datetime."
            )


type alias PostEntry =
    ( Path, EpisodeData )


type alias EpisodeData =
    { number : Int
    , title : String
    , description : String
    , simplecastId : String
    }


view :
    List Episode
    -> Html msg
view episodes =
    div []
        (episodes
            |> List.filterMap
                (\episode ->
                    case episode.publishAt of
                        Scheduled _ ->
                            Nothing

                        Published _ ->
                            Just episode
                )
            |> List.sortBy (\episode -> -episode.number)
            |> List.map episodeView
        )


episodeView : Episode -> Html msg
episodeView episode =
    episode.route
        |> Route.link
            []
            [ div [ class "bg-white shadow-lg px-4 py-2 mb-4 rounded-md" ]
                [ div
                    [ class "flex flex-row justify-between"
                    ]
                    [ div
                        [ class "mr-4 text-highlight"
                        ]
                        [ text <|
                            "#"
                                ++ (episode.number
                                        |> String.fromInt
                                        |> String.padLeft 3 '0'
                                   )
                        ]
                    , div
                        [ style "color" "gray"
                        ]
                        [ text <|
                            " "
                                ++ (episode.publishAt
                                        |> toDate
                                        |> formatDate
                                   )
                        ]
                    ]
                , div [ class "font-bold py-2 text-lg" ] [ text episode.title ]
                , div [ class "pb-4" ] [ text episode.description ]
                ]
            ]


formatDate : Time.Posix -> String
formatDate date =
    date
        |> DateFormat.format
            [ DateFormat.monthNameFull
            , DateFormat.text " "
            , DateFormat.dayOfMonthNumber
            , DateFormat.text ", "
            , DateFormat.yearNumber
            ]
            Time.utc
