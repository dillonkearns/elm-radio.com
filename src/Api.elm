module Api exposing (routes)

import ApiRoute
import DataSource exposing (DataSource)
import Html exposing (Html)
import Path
import PodcastFeed
import Route exposing (Route)
import Sitemap


routes :
    DataSource (List Route)
    -> (Html Never -> String)
    -> List (ApiRoute.Done ApiRoute.Response)
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
    ]
