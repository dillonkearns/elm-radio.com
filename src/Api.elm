module Api exposing (routes)

import ApiRoute
import DataSource exposing (DataSource)
import Episode
import EpisodeFrontmatter
import Html exposing (Html)
import Json.Encode as Encode
import MimeType
import Pages.Manifest as Manifest
import Path
import PodcastFeed
import Route exposing (Route)
import Site
import Sitemap
import Time


routes :
    DataSource (List Route)
    -> (Html Never -> String)
    -> List (ApiRoute.ApiRoute ApiRoute.Response)
routes getStaticRoutes htmlToString =
    [ --Feed.fileToGenerate { siteTagline = siteTagline, siteUrl = canonicalSiteUrl } siteMetadata |> Ok
      --, MySitemap.build { siteUrl = canonicalSiteUrl } siteMetadata |> Ok
      Manifest.generator Site.canonicalUrl (DataSource.succeed manifest)
    , ApiRoute.succeed PodcastFeed.generate
        |> ApiRoute.literal "feed.xml"
        |> ApiRoute.single
    , ApiRoute.succeed
        (getStaticRoutes
            |> DataSource.map
                (\allRoutes ->
                    allRoutes
                        |> List.map
                            (\route ->
                                { path =
                                    route
                                        |> Route.toPath
                                        |> Path.toAbsolute
                                , lastMod = Nothing
                                }
                            )
                        |> Sitemap.build { siteUrl = "https://elm-radio.com" }
                )
        )
        |> ApiRoute.literal "sitemap.xml"
        |> ApiRoute.single
    , ApiRoute.succeed
        (allEpisodes
            |> DataSource.map
                (\episodes ->
                    episodes
                        |> List.sortBy .number
                        |> List.reverse
                        |> List.filterMap
                            (\episode ->
                                case episode.publishAt of
                                    Episode.Scheduled _ ->
                                        Nothing

                                    Episode.Published publishTime ->
                                        Just
                                            (Encode.object
                                                [ ( "title", Encode.string episode.title )
                                                , ( "description", Encode.string episode.description )
                                                , ( "url"
                                                  , Encode.string
                                                        ("https://elm-radio.com" ++ (episode.route |> Route.toPath |> Path.toAbsolute))
                                                  )
                                                , ( "number", Encode.int episode.number )
                                                , ( "published", Encode.int (publishTime |> Time.posixToMillis) )
                                                ]
                                            )
                            )
                        |> Encode.list identity
                        |> Encode.encode 0
                )
        )
        |> ApiRoute.literal "episodes.json"
        |> ApiRoute.single
    ]


manifest : Manifest.Config
manifest =
    Manifest.init
        { name = "Elm Radio Podcast"
        , description = "Elm Radio Podcast"
        , startUrl = Route.Index |> Route.toPath
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
    -> Manifest.Icon
icon format width =
    { src = Site.cloudinaryIcon format width
    , sizes =
        [ ( width, width )
        ]
    , mimeType = format |> Just
    , purposes = [ Manifest.IconPurposeAny, Manifest.IconPurposeMaskable ]
    }


allEpisodes : DataSource (List Episode.Episode)
allEpisodes =
    EpisodeFrontmatter.episodes
        |> DataSource.andThen Episode.request
