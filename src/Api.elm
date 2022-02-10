module Api exposing (routes)

import ApiRoute
import DataSource exposing (DataSource)
import Episode
import EpisodeFrontmatter
import Html exposing (Html)
import Json.Encode as Encode
import Path
import PodcastFeed
import Route exposing (Route)
import Sitemap
import Time


routes :
    DataSource (List Route)
    -> (Html Never -> String)
    -> List (ApiRoute.ApiRoute ApiRoute.Response)
routes getStaticRoutes htmlToString =
    [ --Feed.fileToGenerate { siteTagline = siteTagline, siteUrl = canonicalSiteUrl } siteMetadata |> Ok
      --, MySitemap.build { siteUrl = canonicalSiteUrl } siteMetadata |> Ok
      ApiRoute.succeed PodcastFeed.generate
        |> ApiRoute.literal "feed.xml"
        |> ApiRoute.single
    , ApiRoute.succeed
        (getStaticRoutes
            |> DataSource.map
                (\allRoutes ->
                    { body =
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
                    }
                )
        )
        |> ApiRoute.literal "sitemap.xml"
        |> ApiRoute.single
    , ApiRoute.succeed
        (allEpisodes
            |> DataSource.map
                (\episodes ->
                    { body =
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
                    }
                )
        )
        |> ApiRoute.literal "episodes.json"
        |> ApiRoute.single
    ]


allEpisodes : DataSource (List Episode.Episode)
allEpisodes =
    EpisodeFrontmatter.episodes
        |> DataSource.andThen Episode.request
