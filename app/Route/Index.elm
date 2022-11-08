module Route.Index exposing (ActionData, Data, Model, Msg, route)

import DataSource exposing (DataSource)
import Episode exposing (Episode)
import EpisodeFrontmatter
import Head
import Head.Seo as Seo
import Html exposing (..)
import Html.Attributes as Attr exposing (class)
import Pages.Msg
import Pages.PageUrl exposing (PageUrl)
import Pages.Url
import Path
import Route exposing (Route)
import RouteBuilder exposing (StatelessRoute, StaticPayload)
import Shared
import Site
import Svg exposing (path, svg)
import Svg.Attributes as SvgAttr
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


data : DataSource Data
data =
    EpisodeFrontmatter.episodes
        |> DataSource.andThen Episode.request


head :
    StaticPayload Data ActionData RouteParams
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
    -> StaticPayload Data ActionData RouteParams
    -> View (Pages.Msg.Msg Msg)
view maybeUrl sharedModel static =
    { title = "Elm Radio Podcast"
    , body = landingPageBody static.data |> List.map (Html.map Pages.Msg.UserMsg)
    }


landingPageBody : List Episode -> List (Html msg)
landingPageBody episodeData =
    [ div [ class "" ]
        [ Route.Question
            |> Route.link
                []
                [ button
                    [ class "rounded-lg mb-4 w-full py-2 px-4 text-xl font-semibold border-2 shadow-lg bg-white border-dark"

                    --  flex justify-items-center items-center
                    , Attr.style "display" "flex"
                    , Attr.style "justify-content" "center"
                    , Attr.style "align-items" "center"
                    ]
                    [ Html.span [ Attr.class "mr-3" ] [ questionIcon ]
                    , Html.span [] [ text "Submit Your Question" ]
                    ]
                ]
        , div [] [ h2 [ class "text-lg font-semibold pb-2" ] [ text "Hosted by" ] ]
        , hostsSection
        , div [] [ h2 [ class "text-lg font-semibold pb-2" ] [ text "Episodes" ] ]
        , Episode.view episodeData
        ]
    ]


questionIcon : Html msg
questionIcon =
    svg
        [ Attr.attribute "aria-hidden" "true"
        , Attr.attribute "focusable" "false"
        , Attr.attribute "data-prefix" "fas"
        , Attr.attribute "data-icon" "question-circle"
        , Attr.attribute "width" "20px"

        --, SvgAttr.class "svg-inline--fa fa-question-circle fa-w-16 mr-3"
        , Attr.attribute "role" "img"
        , SvgAttr.viewBox "0 0 512 512"
        ]
        [ path
            [ SvgAttr.fill "currentColor"
            , SvgAttr.d "M504 256c0 136.997-111.043 248-248 248S8 392.997 8 256C8 119.083 119.043 8 256 8s248 111.083 248 248zM262.655 90c-54.497 0-89.255 22.957-116.549 63.758-3.536 5.286-2.353 12.415 2.715 16.258l34.699 26.31c5.205 3.947 12.621 3.008 16.665-2.122 17.864-22.658 30.113-35.797 57.303-35.797 20.429 0 45.698 13.148 45.698 32.958 0 14.976-12.363 22.667-32.534 33.976C247.128 238.528 216 254.941 216 296v4c0 6.627 5.373 12 12 12h56c6.627 0 12-5.373 12-12v-1.333c0-28.462 83.186-29.647 83.186-106.667 0-58.002-60.165-102-116.531-102zM256 338c-25.365 0-46 20.635-46 46 0 25.364 20.635 46 46 46s46-20.636 46-46c0-25.365-20.635-46-46-46z"
            ]
            []
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
                ("https://res.cloudinary.com/dillonkearns/image/upload/w_96,f_auto,q_auto:good/" ++ host.image)
                ("https://res.cloudinary.com/dillonkearns/image/upload/w_192,f_auto,q_auto:good/" ++ host.image)
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
