module Main exposing (main)

import Color
import Date
import Episode
import Feed
import FontAwesome as Fa
import Head
import Head.Seo as Seo
import Html exposing (..)
import Html.Attributes as Attr exposing (class)
import Layout
import Markdown
import MenuSvg
import Metadata exposing (Metadata)
import MySitemap
import Pages exposing (images, pages)
import Pages.Directory as Directory exposing (Directory)
import Pages.Document
import Pages.ImagePath as ImagePath exposing (ImagePath)
import Pages.Manifest as Manifest
import Pages.Manifest.Category
import Pages.PagePath as PagePath exposing (PagePath)
import Pages.Platform exposing (Page)
import Pages.StaticHttp as StaticHttp


manifest : Manifest.Config Pages.PathKey
manifest =
    { backgroundColor = Just Color.white
    , categories = [ Pages.Manifest.Category.education ]
    , displayMode = Manifest.Standalone
    , orientation = Manifest.Portrait
    , description = "elm-pages Tailwind Starter"
    , iarcRatingId = Nothing
    , name = "elm-pages Tailwind Starter"
    , themeColor = Just Color.white
    , startUrl = pages.index
    , shortName = Nothing
    , sourceIcon = images.iconPng
    }


type alias Rendered =
    Html Msg


main : Pages.Platform.Program Model Msg Metadata Rendered
main =
    Pages.Platform.application
        { init = \_ -> init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , documents =
            [ markdownDocument
            ]
        , manifest = manifest
        , canonicalSiteUrl = canonicalSiteUrl
        , onPageChange = \_ -> OnPageChange
        , generateFiles = generateFiles
        , internals = Pages.internals
        }


generateFiles :
    List
        { path : PagePath Pages.PathKey
        , frontmatter : Metadata
        , body : String
        }
    ->
        List
            (Result String
                { path : List String
                , content : String
                }
            )
generateFiles siteMetadata =
    [ Feed.fileToGenerate { siteTagline = siteTagline, siteUrl = canonicalSiteUrl } siteMetadata |> Ok
    , MySitemap.build { siteUrl = canonicalSiteUrl } siteMetadata |> Ok
    ]


markdownDocument : ( String, Pages.Document.DocumentHandler Metadata Rendered )
markdownDocument =
    Pages.Document.parser
        { extension = "md"
        , metadata = Metadata.decoder
        , body =
            \markdownBody ->
                Html.div [] [ Markdown.toHtml [] markdownBody ]
                    |> Ok
        }


type alias Model =
    { menuOpen : Bool
    }


init : ( Model, Cmd Msg )
init =
    ( { menuOpen = False
      }
    , Cmd.none
    )


type Msg
    = OnPageChange
    | ToggleMenu


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnPageChange ->
            ( { model | menuOpen = False }, Cmd.none )

        ToggleMenu ->
            ( { model | menuOpen = not model.menuOpen }, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


view :
    List ( PagePath Pages.PathKey, Metadata )
    ->
        { path : PagePath Pages.PathKey
        , frontmatter : Metadata
        }
    ->
        StaticHttp.Request
            { view : Model -> Rendered -> { title : String, body : Html Msg }
            , head : List (Head.Tag Pages.PathKey)
            }
view siteMetadata page =
    case page.frontmatter of
        Metadata.Page pageData ->
            StaticHttp.succeed
                { view =
                    \model viewForPage ->
                        let
                            { title, body } =
                                pageView model siteMetadata page viewForPage
                        in
                        { title = title
                        , body = Layout.view model ToggleMenu (landingPageBody siteMetadata)
                        }
                , head = head page.frontmatter
                }

        Metadata.Episode episodeData ->
            StaticHttp.succeed
                { view =
                    \model viewForPage ->
                        let
                            { title, body } =
                                pageView model siteMetadata page viewForPage
                        in
                        { title = title
                        , body = Layout.view model ToggleMenu [ viewForPage ]
                        }
                , head = head page.frontmatter
                }


landingPageBody siteMetadata =
    [ div [ class "md:flex flex-grow px-8 py-4" ]
        [ div [ class "flex justify-between mt-2 mb-8 text-3xl" ]
            [ Fa.iconWithOptions Fa.spotify Fa.Solid [] [ Attr.style "color" "#1DB954" ]
            , Fa.iconWithOptions Fa.twitter Fa.Solid [] [ Attr.style "color" "#4AA1ED" ]
            , Fa.iconWithOptions Fa.rss Fa.Solid [] [ Attr.style "color" "#EE802F" ]
            , Fa.iconWithOptions Fa.podcast Fa.Solid [] [ Attr.style "color" "#B150E2" ]
            ]
        , button [ class "rounded-lg mb-4 w-full py-2 px-4 text-xl font-semibold border-2 shadow-lg bg-white border-dark" ]
            [ Fa.iconWithOptions Fa.questionCircle Fa.Solid [] [ class "mr-3" ]
            , text "Submit Your Question"
            ]
        , episodesView siteMetadata
        ]
    ]


episodesView siteMetadata =
    --div [ class "mt-4" ] (List.map episodeView [ () ])
    Episode.view siteMetadata


episodeView episode =
    div [ class "bg-white shadow-lg px-4 py-2" ]
        [ div [ class "text-highlight" ] [ text "#001" ]
        , div [ class "font-bold py-2 text-lg" ] [ text "Getting started with elm-pages" ]

        -- , div [] [ text "Intro to building static sites with elm-pages. We discuss core concepts, and resources for getting started." ]
        , div [ class "pb-4" ] [ text "elm-pages lets you build fast, SEO-friendly static sites with pure Elm. We go over the core concepts, explain Static Sites vs. JAMstack, and give some resources for getting started with elm-pages." ]
        ]


pageView : Model -> List ( PagePath Pages.PathKey, Metadata ) -> { path : PagePath Pages.PathKey, frontmatter : Metadata } -> Rendered -> { title : String, body : Rendered }
pageView model siteMetadata page viewForPage =
    case page.frontmatter of
        Metadata.Page metadata ->
            { title = metadata.title
            , body = Html.text ""
            }

        Metadata.Episode episode ->
            { title = episode.title
            , body = Html.text ""
            }


commonHeadTags : List (Head.Tag Pages.PathKey)
commonHeadTags =
    [ Head.sitemapLink "/sitemap.xml"
    ]


{-| <https://developer.twitter.com/en/docs/tweets/optimize-with-cards/overview/abouts-cards>
<https://htmlhead.dev>
<https://html.spec.whatwg.org/multipage/semantics.html#standard-metadata-names>
<https://ogp.me/>
-}
head : Metadata -> List (Head.Tag Pages.PathKey)
head metadata =
    commonHeadTags
        ++ (case metadata of
                Metadata.Page meta ->
                    Seo.summaryLarge
                        { canonicalUrlOverride = Nothing
                        , siteName = "elm radio"
                        , image =
                            { url = images.iconPng
                            , alt = "elm radio logo"
                            , dimensions = Nothing
                            , mimeType = Nothing
                            }
                        , description = siteTagline
                        , locale = Nothing
                        , title = meta.title
                        }
                        |> Seo.website

                Metadata.Episode episode ->
                    { canonicalUrlOverride = Nothing
                    , siteName = "elm radio"
                    , image =
                        { url = images.iconPng
                        , alt = "elm radio logo"
                        , dimensions = Nothing
                        , mimeType = Nothing
                        }
                    , description = siteTagline
                    , locale = Nothing
                    , title = episode.title
                    }
                        |> Seo.summaryLarge
                        |> Seo.website
           )


canonicalSiteUrl : String
canonicalSiteUrl =
    "https://elm-radio.com"


siteTagline : String
siteTagline =
    "Tune in to the tools and techniques in the Elm ecosystem."
