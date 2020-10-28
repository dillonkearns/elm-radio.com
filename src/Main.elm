module Main exposing (main)

import Cloudinary
import Color
import Episode exposing (Episode)
import Feed
import FontAwesome as Fa
import Head
import Head.Seo as Seo
import Html exposing (..)
import Html.Attributes as Attr exposing (class)
import Layout
import Metadata exposing (Metadata)
import MimeType
import MySitemap
import NetlifyRedirects
import Pages exposing (images, pages)
import Pages.Directory as Directory exposing (Directory)
import Pages.ImagePath as ImagePath exposing (ImagePath)
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
    , icons =
        [ icon webp 192
        , icon webp 512
        , icon MimeType.Png 192
        , icon MimeType.Png 512
        ]
    }


webp : MimeType.MimeImage
webp =
    MimeType.OtherImage "webp"


icon :
    MimeType.MimeImage
    -> Int
    -> Manifest.Icon pathKey
icon format width =
    { src = cloudinaryIcon format width
    , sizes = [ ( width, width ) ]
    , mimeType = format |> Just
    , purposes = [ Manifest.IconPurposeAny, Manifest.IconPurposeMaskable ]
    }


cloudinaryIcon :
    MimeType.MimeImage
    -> Int
    -> ImagePath pathKey
cloudinaryIcon mimeType width =
    Cloudinary.urlSquare "v1602878565/Favicon_Dark_adgn6v.svg" (Just mimeType) width


socialIcon : ImagePath pathKey
socialIcon =
    Cloudinary.urlSquare "v1602878565/Favicon_Dark_adgn6v.svg" Nothing 250


type alias Rendered =
    Html Msg


main : Pages.Platform.Program Model Msg Metadata Rendered Pages.PathKey
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
        |> Pages.Platform.withGlobalHeadTags
            [ Head.icon [ ( 32, 32 ) ] MimeType.Png (cloudinaryIcon MimeType.Png 32)
            , Head.icon [ ( 16, 16 ) ] MimeType.Png (cloudinaryIcon MimeType.Png 16)
            , Head.appleTouchIcon (Just 180) (cloudinaryIcon MimeType.Png 180)
            , Head.appleTouchIcon (Just 192) (cloudinaryIcon MimeType.Png 192)
            ]
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



-- subscriptions : Model -> Sub Msg


subscriptions _ _ _ =
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
                let
                    episodes =
                        siteMetadata
                            |> List.filterMap
                                (\( path, metadata ) ->
                                    case metadata of
                                        Metadata.Episode episodeMetadata ->
                                            Just ( path, episodeMetadata )

                                        _ ->
                                            Nothing
                                )
                in
                StaticHttp.map
                    (\episodeData ->
                        { view =
                            \model viewForPage ->
                                let
                                    { title, body } =
                                        pageView model siteMetadata page viewForPage
                                in
                                { title = title
                                , body = Layout.view model ToggleMenu (landingPageBody episodeData siteMetadata)
                                }
                        , head = head page.frontmatter
                        }
                    )
                    (Episode.request episodes)

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


landingPageBody : List Episode -> List ( PagePath Pages.PathKey, Metadata ) -> List (Html msg)
landingPageBody episodeData siteMetadata =
    [ div [ class "" ]
        [ a [ href Pages.pages.question ]
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


href page =
    Attr.href (PagePath.toString page)


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
