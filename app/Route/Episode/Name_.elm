module Route.Episode.Name_ exposing (ActionData, Data, Model, Msg, route)

import DataSource exposing (DataSource)
import DataSource.File
import DataSource.Glob as Glob
import Episode exposing (Episode)
import Head
import Head.Seo as Seo
import Html exposing (Html)
import Html.Attributes as Attr exposing (class, style)
import Json.Decode as Decode exposing (Decoder)
import Markdown.Block exposing (Block)
import Markdown.Renderer
import MarkdownCodec
import Pages.Msg
import Pages.PageUrl exposing (PageUrl)
import Pages.Url
import Path
import Route
import RouteBuilder exposing (StatelessRoute, StaticPayload)
import Shared
import TailwindMarkdownRenderer
import View exposing (View)


type alias Model =
    {}


type alias Msg =
    ()


type alias RouteParams =
    { name : String }


type alias ActionData =
    {}


route : StatelessRoute RouteParams Data ActionData
route =
    RouteBuilder.preRender
        { head = head
        , pages = pages
        , data = data
        }
        |> RouteBuilder.buildNoState
            { view = view
            }


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


transcriptData : EpisodeData -> DataSource (List Segment)
transcriptData episode =
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
        |> DataSource.File.jsonFile transcriptDecoder


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
    , transcript : List Segment
    }


view :
    Maybe PageUrl
    -> Shared.Model
    -> StaticPayload Data ActionData RouteParams
    -> View (Pages.Msg.Msg Msg)
view maybeUrl sharedModel static =
    { title = static.data.episode.title
    , body =
        [ simplecastPlayer static.data.subData.metadata.simplecastId
        , Html.div
            [ Attr.class "mt-8 bg-white shadow-lg px-8 py-6 mb-4"
            ]
            (static.data.subData.renderedBody
                |> Markdown.Renderer.render TailwindMarkdownRenderer.renderer
                |> Result.withDefault []
            )
        , Html.div []
            (static.data.transcript
                |> List.map
                    (\segment ->
                        Html.div
                            [ class "flex flex-row"
                            ]
                            [ Html.div
                                [ style "color" "gray"
                                , class "mr-4"
                                ]
                                [ Html.text <| formatTimestamp segment.start
                                ]
                            , Html.div [] [ Html.text segment.text ]
                            ]
                    )
            )
        ]
            |> List.map (Html.map Pages.Msg.UserMsg)
    }


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


simplecastPlayer : String -> Html msg
simplecastPlayer simplecastId =
    Html.iframe
        [ Attr.style "height" "200px"
        , Attr.style "width" "100%"
        , Attr.attribute "frameborder" "no"
        , Attr.attribute "scrolling" "no"
        , Attr.attribute "seamless" ""
        , Attr.style "background-color" "white"
        , Attr.src <| "https://player.simplecast.com/" ++ simplecastId ++ "?dark=false&hide_share=true"
        ]
        []
