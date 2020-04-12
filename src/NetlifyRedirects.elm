module NetlifyRedirects exposing (generate)

import Metadata exposing (Metadata)
import Pages
import Pages.PagePath as PagePath exposing (PagePath)


generate :
    List
        { path : PagePath Pages.PathKey
        , frontmatter : Metadata
        , body : String
        }
    ->
        { path : List String
        , content : String
        }
generate siteMetadata =
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
