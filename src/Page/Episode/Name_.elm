module Page.Episode.Name_ exposing (Data, Model, Msg, page)

import DataSource exposing (DataSource)
import DataSource.Glob as Glob
import Episode exposing (Episode)
import Head
import Head.Seo as Seo
import Html exposing (Html)
import Html.Attributes as Attr
import MarkdownCodec
import OptimizedDecoder as Decode exposing (Decoder)
import Page exposing (Page, StaticPayload)
import Pages.PageUrl exposing (PageUrl)
import Pages.Url
import Path
import Route
import Shared
import TailwindMarkdownRenderer
import View exposing (View)


type alias Model =
    ()


type alias Msg =
    Never


type alias RouteParams =
    { name : String }


page : Page RouteParams Data
page =
    Page.prerender
        { head = head
        , routes = routes
        , data = data
        }
        |> Page.buildNoState { view = view }


routes : DataSource (List RouteParams)
routes =
    Glob.succeed RouteParams
        |> Glob.match (Glob.literal "content/episode/")
        |> Glob.capture Glob.wildcard
        |> Glob.match (Glob.literal ".md")
        |> Glob.toDataSource


data : RouteParams -> DataSource Data
data routeParams =
    (("content/episode/" ++ routeParams.name ++ ".md")
        |> MarkdownCodec.withFrontmatter SubData episodeDecoder TailwindMarkdownRenderer.renderer
    )
        |> DataSource.andThen
            (\subData ->
                DataSource.map2 Data
                    (DataSource.succeed subData)
                    (Episode.episodeRequest (Route.Episode__Name_ routeParams) subData.metadata)
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
    StaticPayload Data RouteParams
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
    , renderedBody : List (Html Msg)
    }


type alias Data =
    { subData : SubData
    , episode : Episode
    }


view :
    Maybe PageUrl
    -> Shared.Model
    -> StaticPayload Data RouteParams
    -> View Msg
view maybeUrl sharedModel static =
    { title = static.data.episode.title
    , body =
        [ simplecastPlayer static.data.subData.metadata.simplecastId
        , Html.div
            [ Attr.class "mt-8 bg-white shadow-lg px-8 py-6 mb-4"
            ]
            static.data.subData.renderedBody
        ]
    }


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
