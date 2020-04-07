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
import SubmitQuestion


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
    , generateNetlifyRedirects siteMetadata |> Ok
    ]


generateNetlifyRedirects :
    List
        { path : PagePath Pages.PathKey
        , frontmatter : Metadata
        , body : String
        }
    ->
        { path : List String
        , content : String
        }
generateNetlifyRedirects siteMetadata =
    { path = [ "_redirects" ]
    , content =
        siteMetadata
            |> List.concatMap redirectEntry
            |> String.join "\n"
    }


redirectEntry :
    { path : PagePath Pages.PathKey
    , frontmatter : Metadata
    , body : String
    }
    -> List String
redirectEntry info =
    case info.frontmatter of
        Metadata.Episode episode ->
            [ "/episode/"
                ++ String.fromInt episode.number
                ++ "/:description/content.json "
                ++ PagePath.toString info.path
                ++ "/content.json"
                ++ " 200"
            , "/episode/"
                ++ String.fromInt episode.number
                ++ "/content.json "
                ++ PagePath.toString info.path
                ++ "/content.json"
                ++ " 200"
            , "/episode/"
                ++ String.fromInt episode.number
                ++ "/:description/* "
                ++ PagePath.toString info.path
                ++ "/:splat"
                ++ " 200"
            , "/episode/"
                ++ String.fromInt episode.number
                ++ "/* "
                ++ PagePath.toString info.path
                ++ "/:splat"
                ++ " 200"
            ]

        _ ->
            []


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



-- type PageModel = TopLevelPageModel {} | EpisodePageModel { filters : [] }


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
    let
        _ =
            -- if page.path == Pages.pages.index then
            if Directory.includes Pages.pages.episode.directory page.path then
                ":-)"

            else
                ""
    in
    case page.frontmatter of
        Metadata.Page pageData ->
            if page.path == Pages.pages.question then
                StaticHttp.succeed
                    { view =
                        \model viewForPage ->
                            let
                                { title, body } =
                                    pageView model siteMetadata page viewForPage
                            in
                            { title = title
                            , body = Layout.view model ToggleMenu SubmitQuestion.view
                            }
                    , head = head page.frontmatter
                    }

            else
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
    [ div [ class "px-8 py-4" ]
        [ div
            [ class "flex flex-wrap justify-center mt-2 mb-8 text-3xl"
            , Attr.style "text-shadow" "0 4px 4px rgba(0,0,0,0.05)"
            ]
            [ myIcon Fa.spotify "#1DB954" "https://open.spotify.com/show/3Pcr7EUo1rkouZaMqg34EY" "spotify"
            , myIcon Fa.rss "#EE802F" "https://feeds.simplecast.com/oFjJDJu_" "overcast"
            , myIcon Fa.rss "#EE802F" "https://feeds.simplecast.com/oFjJDJu_" "rss"
            , myIcon Fa.rss "#EE802F" "https://feeds.simplecast.com/oFjJDJu_" "apple-podcasts"

            --, myIcon Fa.twitter "#4AA1ED" "https://twitter.com/elmlangradio" "twitter"
            --, myIcon Fa.rss "#EE802F" "https://feeds.simplecast.com/oFjJDJu_" "rss"
            --, myIcon Fa.podcast "#B150E2" "" "Apple Podcasts"
            ]
        , a [ href Pages.pages.question ]
            [ button [ class "rounded-lg mb-4 w-full py-2 px-4 text-xl font-semibold border-2 shadow-lg bg-white border-dark" ]
                [ Fa.iconWithOptions Fa.questionCircle Fa.Solid [] [ class "mr-3" ]
                , text "Submit Your Question"
                ]
            ]
        , episodesView siteMetadata
        ]
    ]


href page =
    Attr.href (PagePath.toString page)


myIcon fa color url name =
    a
        [ Attr.href url
        , Attr.target "_blank"
        , Attr.rel "noopener noreferrer"
        , class "mx-2"
        ]
        [ --  div
          --     [-- class "border-dark border-2 px-4 py-2"
          --     ]
          --     [ Fa.iconWithOptions fa
          --         Fa.Solid
          --         []
          --         [ Attr.style "color" color
          --         ]
          --     -- , text "Listen on"
          --     ],
          largeIcon fa color name
        ]


largeIcon fa color name =
    img [ class "mb-2", Attr.src ("/badge/" ++ name ++ ".svg") ] []



--div
--    [ class "border border-gray rounded-lg px-4 py-2 text-sm flex bg-black hover:bg-dark flex justify-center"
--    ]
--    [ div
--        [ class "uppercase pr-2"
--        , Attr.style "color" "white"
--        ]
--        [ text "Listen on" ]
--    , Fa.iconWithOptions fa
--        Fa.Solid
--        []
--        [ Attr.style "color" color
--        , class "pr-2"
--        ]
--    , div [ Attr.style "color" "white" ] [ text name ]
--    ]


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
    , Head.rssLink "/feed.xml"
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
