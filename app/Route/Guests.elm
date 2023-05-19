module Route.Guests exposing (ActionData, Data, Model, Msg, route)

import BackendTask exposing (BackendTask)
import FatalError exposing (FatalError)
import Head
import Head.Seo as Seo
import Html exposing (Html)
import Html.Attributes as Attr
import Markdown.Block exposing (Block)
import Markdown.Renderer
import MarkdownCodec
import Pages.PageUrl exposing (PageUrl)
import Pages.Url
import PagesMsg exposing (PagesMsg)
import Path
import RouteBuilder exposing (App, StatelessRoute)
import Shared
import Site
import TailwindMarkdownRenderer
import View exposing (View)


type alias Model =
    {}


type alias Msg =
    ()


type alias RouteParams =
    {}


type alias ActionData =
    {}


route : StatelessRoute RouteParams Data ActionData
route =
    RouteBuilder.single
        { head = head
        , data = data
        }
        |> RouteBuilder.buildNoState { view = view }


type alias Data =
    List Block


data : BackendTask FatalError Data
data =
    "content/guests.md"
        |> MarkdownCodec.withoutFrontmatter TailwindMarkdownRenderer.renderer


head :
    App Data ActionData RouteParams
    -> List Head.Tag
head static =
    Seo.summary
        { canonicalUrlOverride = Nothing
        , siteName = "Elm Radio Podcast"
        , image =
            { url = [ "images", "icon-png.png" ] |> Path.join |> Pages.Url.fromPath
            , alt = "Elm Radio Logo"
            , dimensions = Nothing
            , mimeType = Nothing
            }
        , description = Site.tagline
        , locale = Nothing
        , title = title
        }
        |> Seo.website


view :
    App Data ActionData RouteParams
    -> Shared.Model
    -> View (PagesMsg Msg)
view app sharedModel =
    { title = title
    , body =
        [ Html.div
            [ Attr.class "mt-8 bg-white shadow-lg px-8 py-6 mb-4"
            ]
            (app.data
                |> Markdown.Renderer.render TailwindMarkdownRenderer.renderer
                |> Result.withDefault []
            )
        ]
            |> List.map (Html.map PagesMsg.fromMsg)
    }


title : String
title =
    "Elm Radio Guest Instructions"
