module Episode exposing (Episode, PublishDate(..), episodeRequest, request, view)

import DataSource exposing (DataSource)
import DataSource.Env as Env
import DataSource.File
import DataSource.Glob as Glob
import DataSource.Http as StaticHttp
import DataSource.Port
import Html exposing (..)
import Html.Attributes exposing (..)
import Iso8601
import Json.Decode as Decode exposing (Decoder)
import Json.Encode
import Pages
import Path exposing (Path)
import Route exposing (Route)
import Time


request : List ( Route, EpisodeData ) -> DataSource (List Episode)
request episodes =
    episodes
        |> List.map (\( route, episode ) -> episodeRequest route episode)
        |> DataSource.combine


cachedLookup : Route -> EpisodeData -> DataSource Episode
cachedLookup route episodeData =
    let
        filePath : String
        filePath =
            "simplecast-cache/" ++ String.fromInt episodeData.number ++ ".json"
    in
    Glob.literal filePath
        |> Glob.toDataSource
        |> DataSource.andThen
            (\matchingFiles ->
                if matchingFiles |> List.isEmpty then
                    (Env.expect "SIMPLECAST_TOKEN"
                        |> DataSource.andThen
                            (\simplecastToken ->
                                StaticHttp.uncachedRequest
                                    { method = "GET"
                                    , url = "https://api.simplecast.com/episodes/" ++ episodeData.simplecastId
                                    , headers = [ ( "Authorization", "Bearer " ++ simplecastToken ) ]
                                    , body = StaticHttp.emptyBody
                                    }
                                    (Decode.map2 Tuple.pair Decode.value (episodeDecoder route episodeData)
                                        |> StaticHttp.expectJson
                                    )
                            )
                    )
                        |> DataSource.andThen
                            (\( rawJson, decoded ) ->
                                writeFile
                                    filePath
                                    (Json.Encode.encode 0 rawJson)
                                    |> DataSource.map (\() -> decoded)
                            )

                else
                    DataSource.File.jsonFile
                        (episodeDecoder route episodeData)
                        filePath
            )


writeFile : String -> String -> DataSource ()
writeFile filePath contents =
    DataSource.Port.get "writeFile"
        (Json.Encode.object
            [ ( "filePath", Json.Encode.string filePath )
            , ( "contents", contents |> Json.Encode.string )
            ]
        )
        (Decode.succeed ())


episodeRequest : Route -> EpisodeData -> DataSource Episode
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
                [ div [ class "text-highlight" ]
                    [ text <|
                        "#"
                            ++ (episode.number
                                    |> String.fromInt
                                    |> String.padLeft 3 '0'
                               )
                    ]
                , div [ class "font-bold py-2 text-lg" ] [ text episode.title ]
                , div [ class "pb-4" ] [ text episode.description ]
                ]
            ]
