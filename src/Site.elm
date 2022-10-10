module Site exposing (canonicalUrl, cloudinaryIcon, config, tagline)

import Cloudinary
import DataSource
import Head
import MimeType
import Pages.Url
import SiteConfig exposing (SiteConfig)


type alias Data =
    ()


config : SiteConfig
config =
    { canonicalUrl = canonicalUrl
    , head = head |> DataSource.succeed
    }


canonicalUrl : String
canonicalUrl =
    "https://elm-radio.com"


head : List Head.Tag
head =
    [ Head.sitemapLink "/sitemap.xml"
    , Head.rssLink "/feed.xml"

    -- https://blog.pacific-content.com/optimize-your-podcast-website-for-ios-with-a-single-line-of-code-cf56a7a3f486
    , Head.metaName "apple-itunes-app" (Head.raw "app-id=1506220473")
    , Head.icon [ ( 32, 32 ) ] MimeType.Png (cloudinaryIcon MimeType.Png 32)
    , Head.icon [ ( 16, 16 ) ] MimeType.Png (cloudinaryIcon MimeType.Png 16)
    , Head.appleTouchIcon (Just 180) (cloudinaryIcon MimeType.Png 180)
    , Head.appleTouchIcon (Just 192) (cloudinaryIcon MimeType.Png 192)
    ]


cloudinaryIcon :
    MimeType.MimeImage
    -> Int
    -> Pages.Url.Url
cloudinaryIcon mimeType width =
    Cloudinary.urlSquare "v1602878565/Favicon_Dark_adgn6v.svg" (Just mimeType) width


tagline : String
tagline =
    "Tune in to the tools and techniques in the Elm ecosystem."
