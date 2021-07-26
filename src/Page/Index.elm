module Page.Index exposing (Data, Model, Msg, page)

import DataSource exposing (DataSource)
import DataSource.File
import DataSource.Glob as Glob
import Episode exposing (Episode)
import FontAwesome as Fa
import Head
import Head.Seo as Seo
import Html exposing (..)
import Html.Attributes as Attr exposing (class)
import OptimizedDecoder as Decode exposing (Decoder)
import Page exposing (Page, StaticPayload)
import Pages.PageUrl exposing (PageUrl)
import Pages.Url
import Path exposing (Path)
import Route
import Shared
import Site
import View exposing (View)


type alias Model =
    ()


type alias Msg =
    Never


type alias RouteParams =
    {}


page : Page RouteParams Data
page =
    Page.single
        { head = head
        , data = data
        }
        |> Page.buildNoState { view = view }


data : DataSource Data
data =
    episodes
        |> DataSource.andThen Episode.request


episodes : DataSource (List ( Path, EpisodeData ))
episodes =
    Glob.succeed
        (\name ->
            DataSource.map
                (Tuple.pair (Route.Episode__Name_ { name = name } |> Route.toPath))
                (DataSource.File.onlyFrontmatter episodeDecoder ("content/episode/" ++ name ++ ".md"))
        )
        |> Glob.match (Glob.literal "content/episode/")
        |> Glob.capture Glob.wildcard
        |> Glob.match (Glob.literal ".md")
        |> Glob.toDataSource
        |> DataSource.resolve


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
    Seo.summary
        { canonicalUrlOverride = Nothing
        , siteName = "Elm Radio Podcast"
        , image =
            { url = Path.fromString "/icon-png.png" |> Pages.Url.fromPath
            , alt = "Elm Radio Logo"
            , dimensions = Nothing
            , mimeType = Nothing
            }
        , description = Site.tagline
        , locale = Nothing
        , title = "Elm Radio Podcast"
        }
        |> Seo.website


type alias Data =
    List Episode


view :
    Maybe PageUrl
    -> Shared.Model
    -> StaticPayload Data RouteParams
    -> View Msg
view maybeUrl sharedModel static =
    { title = "Elm Radio Podcast"
    , body = landingPageBody static.data
    }


landingPageBody : List Episode -> List (Html msg)
landingPageBody episodeData =
    [ div [ class "" ]
        [ a [ Attr.href "question" ]
            [ button [ class "rounded-lg mb-4 w-full py-2 px-4 text-xl font-semibold border-2 shadow-lg bg-white border-dark" ]
                [ Fa.iconWithOptions Fa.questionCircle Fa.Solid [] [ class "mr-3" ]
                , text "Submit Your Question"
                ]
            ]
        , div [] [ h2 [ class "text-lg font-semibold pb-2" ] [ text "Hosted by" ] ]
        , hostsSection
        , div [] [ h2 [ class "text-lg font-semibold pb-2" ] [ text "Episodes" ] ]
        , Episode.view episodeData
        ]
    ]


hostsSection =
    div [ Attr.id "hosts" ]
        [ hostCard
            { name = "Dillon Kearns"
            , bio = "elm-pages, elm-graphql, Incremental Elm Consulting"
            , image = "v1602899672/elm-radio/dillon-profile_n2lqst.jpg"
            }
        , hostCard
            { name = "Jeroen Engels"
            , bio = "elm-review, @Humio"
            , image = "v1602899672/elm-radio/jeroen_g9gfpv.png"
            }
        ]


hostCard : { a | image : String, name : String, bio : String } -> Html msg
hostCard host =
    div
        [ class "bg-white shadow-lg px-4 py-2 mb-4 flex flex-row rounded-md"
        ]
        [ div [ class "w-24 flex-shrink-0" ]
            [ --img
              --    [ class "w-24 rounded-lg"
              --    , Attr.src <| "https://res.cloudinary.com/dillonkearns/image/upload/w_96,f_auto,q_auto:best/" ++ host.image
              --    , Attr.alt host.name
              --    ]
              --    []
              responsiveImage host.name
                ("https://res.cloudinary.com/dillonkearns/image/upload/w_96,f_auto,q_auto:best/" ++ host.image)
                ("https://res.cloudinary.com/dillonkearns/image/upload/w_192,f_auto,q_auto:best/" ++ host.image)
            ]
        , div [ class "pl-4 " ]
            [ div [ class "font-bold py-2 text-lg" ] [ text host.name ]

            -- , div [] [ text "Intro to building static sites with elm-pages. We discuss core concepts, and resources for getting started." ]
            , div [ class "pb-4" ] [ text host.bio ]
            ]
        ]


{-| <https://web.dev/serve-responsive-images>
-}
responsiveImage alt smallUrl largeUrl =
    img
        [ Attr.attribute "src" largeUrl
        , Attr.attribute "srcset" (smallUrl ++ " 480w, " ++ largeUrl ++ " 1080w")
        , Attr.attribute "sizes" "50vw"
        , class "w-24 rounded-lg"
        , Attr.alt alt
        ]
        []
