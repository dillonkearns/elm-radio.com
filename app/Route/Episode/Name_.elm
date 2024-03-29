port module Route.Episode.Name_ exposing (ActionData, Data, Model, Msg, route)

import BackendTask exposing (BackendTask)
import BackendTask.Glob as Glob
import Data.Transcript as Transcript
import Effect exposing (Effect)
import Episode exposing (Episode)
import FatalError exposing (FatalError)
import Head
import Head.Seo as Seo
import Html exposing (Html)
import Html.Attributes as Attr exposing (class)
import Html.Events exposing (onClick)
import Html.Keyed
import Html.Lazy
import Json.Decode as Decode exposing (Decoder)
import Json.Encode
import Markdown.Block exposing (Block)
import Markdown.Renderer
import MarkdownCodec
import Pages.PageUrl exposing (PageUrl)
import Pages.Url
import PagesMsg exposing (PagesMsg)
import Path exposing (Path)
import Route
import RouteBuilder exposing (App, StatefulRoute, StatelessRoute)
import Shared
import TailwindMarkdownRenderer
import View exposing (View)


type alias Model =
    { seconds : Float
    , currentTime : Float
    , duration : Float
    }


type Msg
    = SeekTo Float
    | ReceiveProgress Decode.Value


type alias RouteParams =
    { name : String }


type alias ActionData =
    {}


route : StatefulRoute RouteParams Data ActionData Model Msg
route =
    RouteBuilder.preRender
        { head = head
        , pages = pages
        , data = data
        }
        |> RouteBuilder.buildWithLocalState
            { view = view
            , init = init
            , update = update
            , subscriptions = \_ _ _ _ -> Sub.none
            }


init :
    App data action routeParams
    -> Shared.Model
    -> ( Model, Effect Msg )
init app shared =
    let
        startingTime : Float
        startingTime =
            case app.url |> Maybe.andThen .fragment |> Maybe.map (String.split "-") of
                Just [ hours, minutes, seconds ] ->
                    Maybe.map3
                        (\h m s ->
                            (h * 60 * 60)
                                + (m * 60)
                                + s
                                |> toFloat
                        )
                        (String.toInt hours)
                        (String.toInt minutes)
                        (String.toInt seconds)
                        |> Maybe.withDefault 0

                _ ->
                    0
    in
    ( { seconds = startingTime
      , currentTime = startingTime
      , duration = 0
      }
    , Effect.none
    )


update :
    App Data ActionData RouteParams
    -> Shared.Model
    -> Msg
    -> Model
    -> ( Model, Effect Msg )
update app shared msg model =
    case msg of
        SeekTo seconds ->
            ( { model | seconds = seconds }
            , Effect.none
            )

        ReceiveProgress value ->
            let
                decoder : Decoder ( Float, Float )
                decoder =
                    Decode.map2 Tuple.pair
                        (Decode.field "currentTime" Decode.float)
                        (Decode.field "duration" Decode.float)
            in
            case Decode.decodeValue decoder value of
                Ok ( currentTime, duration ) ->
                    ( { model
                        | currentTime = currentTime
                        , duration = duration
                      }
                    , Effect.none
                    )

                Err _ ->
                    ( model, Effect.none )


subscriptions : Maybe PageUrl -> routeParams -> Path -> Shared.Model -> Model -> Sub Msg
subscriptions _ _ _ _ _ =
    receiveProgress ReceiveProgress


pages : BackendTask FatalError (List RouteParams)
pages =
    Glob.succeed RouteParams
        |> Glob.match (Glob.literal "content/episode/")
        |> Glob.capture Glob.wildcard
        |> Glob.match (Glob.literal ".md")
        |> Glob.toBackendTask


data : RouteParams -> BackendTask FatalError Data
data routeParams =
    (("content/episode/" ++ routeParams.name ++ ".md")
        |> MarkdownCodec.withFrontmatter SubData
            episodeDecoder
            TailwindMarkdownRenderer.renderer
    )
        |> BackendTask.andThen
            (\subData ->
                BackendTask.map3 Data
                    (BackendTask.succeed subData)
                    (Episode.episodeRequest (Route.Episode__Name_ routeParams) subData.metadata)
                    (Transcript.transcriptData subData.metadata)
            )


type alias EpisodeData =
    { number : Int
    , title : String
    , description : String
    , simplecastId : String
    }


episodeDecoder : Decoder EpisodeData
episodeDecoder =
    Decode.map4 EpisodeData
        (Decode.field "number" Decode.int)
        (Decode.field "title" Decode.string)
        (Decode.field "description" Decode.string)
        (Decode.field "simplecastId" Decode.string)


head :
    App Data ActionData RouteParams
    -> List Head.Tag
head static =
    (case static.data.episode.publishAt of
        Episode.Scheduled _ ->
            [ Head.metaName "robots" (Head.raw "noindex")
            ]

        Episode.Published _ ->
            []
    )
        ++ ({ canonicalUrlOverride = Nothing
            , siteName = "Elm Radio Podcast"
            , image =
                { url = Path.fromString "/icon-png.png" |> Pages.Url.fromPath
                , alt = "Elm Radio Logo"
                , dimensions = Nothing
                , mimeType = Nothing
                }
            , description = static.data.episode.description
            , locale = Nothing
            , title = "Episode " ++ String.fromInt static.data.episode.number ++ ": " ++ static.data.episode.title
            }
                |> Seo.summary
                |> Seo.website
           )


type alias SubData =
    { metadata : EpisodeData
    , renderedBody : List Block
    }


type alias Data =
    { subData : SubData
    , episode : Episode
    , transcript : Maybe (List Transcript.Segment)
    }


view :
    App Data ActionData RouteParams
    -> Shared.Model
    -> Model
    -> View (PagesMsg Msg)
view app sharedModel model =
    { title = app.data.episode.title
    , body =
        [ Html.div
            [ class "flex flex-col text-lg mb-8 mt-8 bg-white shadow-lg px-8 py-6 mb-4"
            ]
            [ Html.div []
                [ Html.h2
                    [ class "text-2xl text-center mb-8 font-semibold "
                    ]
                    [ Html.text app.data.episode.title
                    ]
                ]
            , Html.div
                []
                [ Html.text app.data.episode.description ]
            , Html.div
                [ class "flex flex-row justify-between mt-8"
                ]
                [ Html.div
                    [ class "flex flex-row border-2 p-2 gap-1"
                    ]
                    [ Html.span
                        [ class "hidden lg:inline" ]
                        [ Html.text "Published" ]
                    , app.data.episode.publishAt
                        |> Episode.toDate
                        |> Episode.formatDate
                        |> Html.text
                    ]
                , Html.div
                    [ class "flex flex-row border-2 p-2 gap-1"
                    ]
                    [ Html.span
                        [ class "hidden lg:block"
                        ]
                        [ Html.text "Episode"
                        ]
                    , Html.text <| "#" ++ String.fromInt app.data.episode.number
                    ]
                ]
            ]
        , Html.Lazy.lazy2 audioPlayer
            model.seconds
            app.data.episode.audio.url
        , Html.div
            [ Attr.class "mt-8 bg-white shadow-lg px-8 py-6 mb-4"
            ]
            (app.data.subData.renderedBody
                |> Markdown.Renderer.render TailwindMarkdownRenderer.renderer
                |> Result.withDefault []
            )
        , Html.Lazy.lazy2 transcriptArea model.currentTime app.data.transcript
        ]
            |> List.map (Html.map PagesMsg.fromMsg)
    }


transcriptArea : Float -> Maybe (List Transcript.Segment) -> Html Msg
transcriptArea currentTime maybeTranscript =
    Html.div
        [ class "mt-8 bg-white shadow-lg px-8 py-6 mb-4"
        ]
        (Html.h2
            [ class "text-xl font-semibold pb-6 text-center"
            ]
            [ Html.text "Transcript"
            ]
            :: [ case maybeTranscript of
                    Just transcript ->
                        Html.div
                            [ Attr.class " mt-1 -space-y-px rounded-md bg-white shadow-sm"
                            ]
                            (transcriptSection currentTime transcript)

                    Nothing ->
                        Html.text "No transcript yet."
               ]
        )


transcriptSection : Float -> List Transcript.Segment -> List (Html Msg)
transcriptSection currentTime transcript =
    transcript
        |> List.foldr
            (\item ( alreadyFoundCurrentTime, result ) ->
                let
                    isAtLeastCurrentTime : Bool
                    isAtLeastCurrentTime =
                        floor currentTime >= floor item.start

                    isCurrent : Bool
                    isCurrent =
                        not alreadyFoundCurrentTime && isAtLeastCurrentTime
                in
                ( isAtLeastCurrentTime
                , Html.a
                    [ class
                        (if not alreadyFoundCurrentTime && isAtLeastCurrentTime then
                            "rounded-tl-md rounded-tr-md relative border p-4 flex cursor-pointer focus:outline-none bg-sky-50 border-sky-200 z-10 hover:underline"

                         else
                            "relative border p-4 flex cursor-pointer focus:outline-none border-gray-200 hover:underline"
                        )
                    , onClick (SeekTo item.start)
                    , Attr.name (formatTimestamp item.start |> String.replace ":" "-")
                    , Attr.href ("#" ++ (formatTimestamp item.start |> String.replace ":" "-"))
                    ]
                    [ Html.div
                        [ class
                            (if isCurrent then
                                "mr-4 text-sm text-gray-600"

                             else
                                "mr-4 text-sm text-gray-400"
                            )
                        ]
                        [ Html.text <| "[" ++ formatTimestamp item.start ++ "]"
                        ]
                    , Html.div
                        [ class
                            (if isCurrent then
                                "block font-medium text-sky-700"

                             else
                                "block font-medium text-gray-800"
                            )
                        ]
                        [ Html.text item.text ]
                    ]
                    :: result
                )
            )
            ( False, [] )
        |> Tuple.second


formatTimestamp : Float -> String
formatTimestamp number =
    let
        float =
            number |> floor

        hours : Int
        hours =
            floor (number / 3600)

        minutes : Int
        minutes =
            floor ((number - toFloat (hours * 3600)) / 60)

        seconds : Int
        seconds =
            float - (hours * 3600) - (minutes * 60)
    in
    timestampPaddedInt hours
        ++ ":"
        ++ timestampPaddedInt minutes
        ++ ":"
        ++ timestampPaddedInt seconds


timestampPaddedInt : Int -> String
timestampPaddedInt int =
    String.fromInt int |> String.padLeft 2 '0'


audioPlayer : Float -> String -> Html msg
audioPlayer time audioPath =
    Html.Keyed.node "div"
        [ Attr.style "position" "sticky"
        , Attr.style "top" "0"
        , Attr.style "background" "white"
        , Attr.style "z-index" "1000"
        ]
        [ ( "plyr-" ++ audioPath
          , Html.node "plyr-audio"
                [ Attr.src audioPath
                , Attr.property "seconds" (Json.Encode.string (String.fromFloat time))
                ]
                []
          )
        ]


port receiveProgress : (Decode.Value -> msg) -> Sub msg
