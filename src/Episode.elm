module Episode exposing (Episode, PublishDate(..), episodeRequest, request, view)

--import Json.Decode as Decode exposing (Decoder)

import Html exposing (..)
import Html.Attributes exposing (..)
import Iso8601
import Metadata exposing (Metadata)
import OptimizedDecoder as Decode exposing (Decoder)
import Pages
import Pages.PagePath as PagePath exposing (PagePath)
import Pages.Secrets as Secrets
import Pages.StaticHttp as StaticHttp
import Time


request : List ( PagePath Pages.PathKey, Metadata.EpisodeData ) -> StaticHttp.Request (List Episode)
request episodes =
    episodes
        |> List.map (\( path, episode ) -> episodeRequest path episode)
        |> StaticHttp.combine


episodeRequest : PagePath Pages.PathKey -> Metadata.EpisodeData -> StaticHttp.Request Episode
episodeRequest path episodeData =
    StaticHttp.request
        (Secrets.succeed
            (\simplecastToken ->
                { method = "GET"
                , url = "https://api.simplecast.com/episodes/" ++ episodeData.simplecastId
                , headers = [ ( "Authorization", "Bearer " ++ simplecastToken ) ]
                , body = StaticHttp.emptyBody
                }
            )
            |> Secrets.with "SIMPLECAST_TOKEN"
        )
        (episodeDecoder path episodeData)


type alias Episode =
    { title : String
    , description : String
    , guid : String
    , path : PagePath Pages.PathKey
    , publishAt : PublishDate
    , duration : Int
    , number : Int
    , audio :
        { url : String
        , sizeInBytes : Int
        }
    }


episodeDecoder : PagePath Pages.PathKey -> Metadata.EpisodeData -> Decoder Episode
episodeDecoder path episodeData =
    Decode.map4
        (Episode episodeData.title episodeData.description episodeData.simplecastId path)
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
            |> Decode.map Scheduled
        , Decode.field "published_at" iso8601Decoder
            |> Decode.map Published
        ]


iso8601Decoder : Decoder Time.Posix
iso8601Decoder =
    Decode.string
        |> Decode.andThen
            (\datetimeString ->
                case Iso8601.toTime datetimeString of
                    Ok time ->
                        Decode.succeed time

                    Err message ->
                        Decode.fail "Could not parse datetime."
            )


type alias PostEntry =
    ( PagePath Pages.PathKey, Metadata.EpisodeData )


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

                        Published publishedAt ->
                            Just episode
                )
            |> List.sortBy (\episode -> -episode.number)
            |> List.map episodeView
        )


episodeView episode =
    a [ href (PagePath.toString episode.path) ]
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
