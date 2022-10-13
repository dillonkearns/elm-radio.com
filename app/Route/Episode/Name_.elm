module Route.Episode.Name_ exposing (ActionData, Data, Model, Msg, route)

import DataSource exposing (DataSource)
import DataSource.File
import DataSource.Glob as Glob
import Effect exposing (Effect)
import Episode exposing (Episode)
import Head
import Head.Seo as Seo
import Html exposing (Html)
import Html.Attributes as Attr exposing (class, style)
import Html.Events exposing (onClick)
import Html.Keyed
import Html.Lazy
import Json.Decode as Decode exposing (Decoder)
import Json.Encode
import Markdown.Block exposing (Block)
import Markdown.Renderer
import MarkdownCodec
import Pages.Msg
import Pages.PageUrl exposing (PageUrl)
import Pages.Url
import Path exposing (Path)
import Route
import RouteBuilder exposing (StatefulRoute, StatelessRoute, StaticPayload)
import Shared
import TailwindMarkdownRenderer
import View exposing (View)


type alias Model =
    { seconds : Float
    }


type Msg
    = SeekTo Float


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
            , subscriptions = subscriptions
            }


init :
    Maybe PageUrl
    -> Shared.Model
    -> StaticPayload data action routeParams
    -> ( Model, Effect Msg )
init maybeUrl shared app =
    ( { seconds = 0
      }
    , Effect.none
    )


update :
    PageUrl
    -> Shared.Model
    -> StaticPayload Data ActionData RouteParams
    -> Msg
    -> Model
    -> ( Model, Effect Msg )
update url shared app msg model =
    case msg of
        SeekTo seconds ->
            ( { model | seconds = seconds }
            , Effect.none
            )


subscriptions : Maybe PageUrl -> routeParams -> Path -> Shared.Model -> Model -> Sub Msg
subscriptions _ _ _ _ _ =
    Sub.none


pages : DataSource (List RouteParams)
pages =
    Glob.succeed RouteParams
        |> Glob.match (Glob.literal "content/episode/")
        |> Glob.capture Glob.wildcard
        |> Glob.match (Glob.literal ".md")
        |> Glob.toDataSource


data : RouteParams -> DataSource Data
data routeParams =
    (("content/episode/" ++ routeParams.name ++ ".md")
        |> MarkdownCodec.withFrontmatter SubData
            episodeDecoder
            TailwindMarkdownRenderer.renderer
    )
        |> DataSource.andThen
            (\subData ->
                DataSource.map3 Data
                    (DataSource.succeed subData)
                    (Episode.episodeRequest (Route.Episode__Name_ routeParams) subData.metadata)
                    (transcriptData subData.metadata)
            )


transcriptData : EpisodeData -> DataSource (Maybe (List Segment))
transcriptData episode =
    let
        fileName : String
        fileName =
            episodeFilePath episode

        checkTranscriptExists : DataSource Bool
        checkTranscriptExists =
            Glob.literal fileName
                |> Glob.toDataSource
                |> DataSource.map (\list -> List.length list > 0)
    in
    checkTranscriptExists
        |> DataSource.andThen
            (\transcriptExists ->
                if transcriptExists then
                    fileName
                        |> DataSource.File.jsonFile transcriptDecoder
                        |> DataSource.map Just

                else
                    DataSource.succeed Nothing
            )


episodeFilePath : EpisodeData -> String
episodeFilePath episode =
    let
        paddedNumber : String
        paddedNumber =
            String.fromInt episode.number
                |> String.padLeft 3 '0'

        fileName : String
        fileName =
            "transcripts/" ++ paddedNumber ++ "/" ++ paddedNumber ++ ".json"
    in
    fileName


type alias Segment =
    { start : Float
    , end : Float
    , text : String
    }


transcriptDecoder : Decoder (List Segment)
transcriptDecoder =
    Decode.field "segments"
        (Decode.list
            (Decode.map3 Segment
                (Decode.field "start" Decode.float)
                (Decode.field "end" Decode.float)
                (Decode.field "text" Decode.string)
            )
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
    StaticPayload Data ActionData RouteParams
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
    , transcript : Maybe (List Segment)
    }


view :
    Maybe PageUrl
    -> Shared.Model
    -> Model
    -> StaticPayload Data ActionData RouteParams
    -> View (Pages.Msg.Msg Msg)
view maybeUrl sharedModel model app =
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
        , Html.div
            [ class "mt-8 bg-white shadow-lg px-8 py-6 mb-4"
            ]
            (Html.h2
                [ class "text-xl font-semibold pb-6 text-center"
                ]
                [ Html.text "Transcript"
                ]
                :: (case app.data.transcript of
                        Just transcript ->
                            transcriptSection transcript

                        Nothing ->
                            [ Html.text "No transcript yet." ]
                   )
            )
        ]
            |> List.map (Html.map Pages.Msg.UserMsg)
    }


transcriptSection : List Segment -> List (Html Msg)
transcriptSection transcript =
    transcript
        |> List.map
            (\segment ->
                Html.p
                    [ class "flex flex-row hover:underline cursor-pointer pb-4"
                    , onClick (SeekTo segment.start)
                    ]
                    [ Html.div
                        [ style "color" "gray"
                        , class "mr-4"
                        ]
                        [ Html.text <| "[" ++ formatTimestamp segment.start ++ "]"
                        ]
                    , Html.div [] [ Html.text segment.text ]
                    ]
            )


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
        ]
        [ ( "plyr-" ++ audioPath
          , Html.node "plyr-audio"
                [ Attr.src audioPath
                , Attr.property "seconds" (Json.Encode.string (String.fromFloat time))
                ]
                []
          )
        ]
