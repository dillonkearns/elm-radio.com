module MySitemap exposing (..)

import Metadata exposing (Metadata(..))
import Pages
import Pages.PagePath as PagePath exposing (PagePath)
import Sitemap


build :
    { siteUrl : String
    }
    ->
        List
            { path : PagePath Pages.PathKey
            , frontmatter : Metadata
            , body : String
            }
    ->
        { path : List String
        , content : String
        }
build config siteMetadata =
    { path = [ "sitemap.xml" ]
    , content =
        Sitemap.build config
            (siteMetadata
                |> List.filter
                    (\page ->
                        case page.frontmatter of
                            Episode _ ->
                                True

                            Page _ ->
                                True
                    )
                |> List.map
                    (\page ->
                        { path = PagePath.toString page.path, lastMod = Nothing }
                    )
            )
    }
