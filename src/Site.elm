module Site exposing (config, tagline)

import Cloudinary
import DataSource
import Head
import MimeType
import Pages.Manifest as Manifest
import Pages.Url
import Route
import SiteConfig exposing (SiteConfig)


type alias Data =
    ()


config : SiteConfig Data
config =
    \_ ->
        { data = data
        , canonicalUrl = "https://elm-radio.com"
        , manifest = manifest
        , head = head
        }


data : DataSource.DataSource Data
data =
    DataSource.succeed ()


head : Data -> List Head.Tag
head static =
    [ Head.sitemapLink "/sitemap.xml"
    , Head.rssLink "/feed.xml"

    -- https://blog.pacific-content.com/optimize-your-podcast-website-for-ios-with-a-single-line-of-code-cf56a7a3f486
    , Head.metaName "apple-itunes-app" (Head.raw "app-id=1506220473")
    , Head.icon [ ( 32, 32 ) ] MimeType.Png (cloudinaryIcon MimeType.Png 32)
    , Head.icon [ ( 16, 16 ) ] MimeType.Png (cloudinaryIcon MimeType.Png 16)
    , Head.appleTouchIcon (Just 180) (cloudinaryIcon MimeType.Png 180)
    , Head.appleTouchIcon (Just 192) (cloudinaryIcon MimeType.Png 192)
    ]


manifest : Data -> Manifest.Config
manifest static =
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
    { src = cloudinaryIcon format width
    , sizes =
        [ ( width, width )
        ]
    , mimeType = format |> Just
    , purposes = [ Manifest.IconPurposeAny, Manifest.IconPurposeMaskable ]
    }


cloudinaryIcon :
    MimeType.MimeImage
    -> Int
    -> Pages.Url.Url
cloudinaryIcon mimeType width =
    Cloudinary.urlSquare "v1602878565/Favicon_Dark_adgn6v.svg" (Just mimeType) width


tagline : String
tagline =
    "Tune in to the tools and techniques in the Elm ecosystem."
