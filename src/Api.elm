module Api exposing (routes)

import ApiRoute
import DataSource exposing (DataSource)
import Html exposing (Html)
import PodcastFeed
import Route exposing (Route)


routes :
    DataSource (List Route)
    -> (Html Never -> String)
    -> List (ApiRoute.Done ApiRoute.Response)
routes getStaticRoutes htmlToString =
    [ --Feed.fileToGenerate { siteTagline = siteTagline, siteUrl = canonicalSiteUrl } siteMetadata |> Ok
      --, MySitemap.build { siteUrl = canonicalSiteUrl } siteMetadata |> Ok
      ApiRoute.succeed (PodcastFeed.generate htmlToString)
        |> ApiRoute.literal "feed.xml"
        |> ApiRoute.single
    ]
