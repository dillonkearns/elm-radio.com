module Main exposing (main)

import Color
import Episode
import Feed
import FontAwesome as Fa
import Head
import Head.Seo as Seo
import Html exposing (..)
import Html.Attributes as Attr exposing (class)
import Layout
import Metadata exposing (Metadata)
import MySitemap
import NetlifyRedirects
import Pages exposing (images, pages)
import Pages.Directory as Directory exposing (Directory)
import Pages.ImagePath as ImagePath
import Pages.Manifest as Manifest
import Pages.Manifest.Category
import Pages.PagePath as PagePath exposing (PagePath)
import Pages.Platform exposing (Page)
import Pages.StaticHttp as StaticHttp
import PodcastFeed
import SubmitQuestion
import TailwindMarkdownRenderer


manifest : Manifest.Config Pages.PathKey
manifest =
    { backgroundColor = Just Color.white
    , categories = [ Pages.Manifest.Category.education ]
    , displayMode = Manifest.Standalone
    , orientation = Manifest.Portrait
    , description = "Elm Radio Podcast"
    , iarcRatingId = Nothing
    , name = "Elm Radio Podcast"
    , themeColor = Just Color.white
    , startUrl = pages.index
    , shortName = Just "Elm Radio"
    , sourceIcon = images.iconPng
    }


type alias Rendered =
    Html Msg


main : Pages.Platform.Program Model Msg Metadata Rendered
main =
    Pages.Platform.init
        { init = \_ -> init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , documents =
            [ { extension = "md"
              , metadata = Metadata.decoder
              , body =
                    \markdownBody ->
                        TailwindMarkdownRenderer.renderMarkdown markdownBody
                            |> Result.map
                                (Html.div
                                    [ Attr.class "mt-8 bg-white shadow-lg px-8 py-6 mb-4"
                                    ]
                                )
              }
            ]
        , manifest = manifest
        , canonicalSiteUrl = canonicalSiteUrl
        , onPageChange = Just (\_ -> OnPageChange)
        , internals = Pages.internals
        }
        |> Pages.Platform.withFileGenerator generateFiles
        |> Pages.Platform.withFileGenerator PodcastFeed.generate
        |> Pages.Platform.toProgram


generateFiles :
    List
        { path : PagePath Pages.PathKey
        , frontmatter : Metadata
        , body : String
        }
    ->
        StaticHttp.Request
            (List
                (Result String
                    { path : List String
                    , content : String
                    }
                )
            )
generateFiles siteMetadata =
    StaticHttp.succeed
        [ Feed.fileToGenerate { siteTagline = siteTagline, siteUrl = canonicalSiteUrl } siteMetadata |> Ok
        , MySitemap.build { siteUrl = canonicalSiteUrl } siteMetadata |> Ok

        -- , NetlifyRedirects.generate siteMetadata |> Ok
        ]


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
                        , body =
                            Layout.view model
                                ToggleMenu
                                [ simplecastPlayer episodeData.simplecastId
                                , viewForPage
                                ]
                        }
                , head = head page.frontmatter
                }


simplecastPlayer : String -> Html msg
simplecastPlayer simplecastId =
    Html.iframe
        [ Attr.style "height" "200px"
        , Attr.style "width" "100%"
        , Attr.attribute "frameborder" "no"
        , Attr.attribute "scrolling" "no"
        , Attr.attribute "seamless" ""
        , Attr.src <| "https://player.simplecast.com/" ++ simplecastId ++ "?dark=false&hide_share=true"
        ]
        []


landingPageBody siteMetadata =
    [ div [ class "" ]
        [ div
            [ class "flex flex-wrap justify-center mt-2 mb-8 text-3xl"
            , Attr.style "text-shadow" "0 4px 4px rgba(0,0,0,0.05)"
            ]
            [ podcastBadge "https://open.spotify.com/show/3Pcr7EUo1rkouZaMqg34EY" "spotify"
            , podcastBadge "https://overcast.fm/itunes1506220473/elm-radio" "overcast"
            , podcastBadge "https://elm-radio.com/feed.xml" "rss"
            , podcastBadge "https://podcasts.apple.com/us/podcast/elm-radio/id1506220473?mt=2&app=podcast" "apple-podcasts"
            ]
        , a [ href Pages.pages.question ]
            [ button [ class "rounded-lg mb-4 w-full py-2 px-4 text-xl font-semibold border-2 shadow-lg bg-white border-dark" ]
                [ Fa.iconWithOptions Fa.questionCircle Fa.Solid [] [ class "mr-3" ]
                , text "Submit Your Question"
                ]
            ]
        , div [] [ h2 [ class "text-lg font-semibold pb-2" ] [ text "Hosted by" ] ]
        , hostsSection
        , div [] [ h2 [ class "text-lg font-semibold pb-2" ] [ text "Episodes" ] ]
        , Episode.view siteMetadata
        ]
    ]


hostsSection =
    div [ Attr.id "hosts" ]
        [ hostCard { name = "Dillon Kearns", bio = "elm-pages, elm-graphql, Incremental Elm Consulting", image = Pages.images.dillon }
        , hostCard { name = "Jeroen Engels", bio = "elm-review, @Humio", image = Pages.images.jeroen }
        ]


hostCard : { a | image : ImagePath.ImagePath key, name : String, bio : String } -> Html msg
hostCard host =
    div
        [ class "bg-white shadow-lg px-4 py-2 mb-4 flex flex-row rounded-md"
        ]
        [ div [ class "w-24 flex-shrink-0" ]
            [ img
                [ class "w-24 rounded-lg"
                , Attr.src <| ("/" ++ ImagePath.toString host.image)
                ]
                []
            ]
        , div [ class "pl-4 " ]
            [ div [ class "font-bold py-2 text-lg" ] [ text host.name ]

            -- , div [] [ text "Intro to building static sites with elm-pages. We discuss core concepts, and resources for getting started." ]
            , div [ class "pb-4" ] [ text host.bio ]
            ]
        ]


href page =
    Attr.href (PagePath.toString page)


podcastBadge : String -> String -> Html msg
podcastBadge url name =
    a
        [ Attr.href url
        , Attr.target "_blank"
        , Attr.rel "noopener noreferrer"
        , class "mx-2"
        ]
        [ img
            [ class "mb-2"
            , Attr.src ("/badge/" ++ name ++ ".svg")
            , Attr.alt name
            ]
            []
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
                    Seo.summary
                        { canonicalUrlOverride = Nothing
                        , siteName = "Elm Radio Podcast"
                        , image =
                            { url = images.iconPng
                            , alt = "Elm Radio Logo"
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
                    , siteName = "Elm Radio Podcast"
                    , image =
                        { url = images.iconPng
                        , alt = "Elm Radio Logo"
                        , dimensions = Nothing
                        , mimeType = Nothing
                        }
                    , description = episode.description
                    , locale = Nothing
                    , title = "Episode " ++ String.fromInt episode.number ++ ": " ++ episode.title
                    }
                        |> Seo.summary
                        |> Seo.website
           )


canonicalSiteUrl : String
canonicalSiteUrl =
    "https://elm-radio.com"


siteTagline : String
siteTagline =
    "Tune in to the tools and techniques in the Elm ecosystem."
