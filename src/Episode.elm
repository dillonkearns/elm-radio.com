module Episode exposing (view)

import Date
import Html exposing (..)
import Html.Attributes exposing (..)
import Metadata exposing (Metadata)
import Pages
import Pages.PagePath as PagePath exposing (PagePath)
import Pages.Platform exposing (Page)


type alias PostEntry =
    ( PagePath Pages.PathKey, Metadata.EpisodeData )


view :
    List ( PagePath Pages.PathKey, Metadata )
    -> Html msg
view posts =
    div []
        (posts
            |> List.filterMap
                (\( path, metadata ) ->
                    case metadata of
                        Metadata.Page meta ->
                            Nothing

                        Metadata.Episode meta ->
                            --if meta.draft then
                            --    Nothing
                            --
                            --else
                            Just ( path, meta )
                )
            |> List.sortBy (\( _, episode ) -> -episode.number)
            |> List.map episodeView
        )


episodeView ( path, episode ) =
    div [ class "bg-white shadow-lg px-4 py-2 mb-4" ]
        [ div [ class "text-highlight" ]
            [ text <|
                "#"
                    ++ (episode.number
                            |> String.fromInt
                            |> String.padLeft 3 '0'
                       )
            ]
        , div [ class "font-bold py-2 text-lg" ] [ text episode.title ]

        -- , div [] [ text "Intro to building static sites with elm-pages. We discuss core concepts, and resources for getting started." ]
        , div [ class "pb-4" ] [ text episode.description ]
        ]



--postPublishDateAscending : PostEntry -> PostEntry -> Order
--postPublishDateAscending ( _, metadata1 ) ( _, metadata2 ) =
--    Date.compare metadata1.published metadata2.published
--
--
--postPublishDateDescending : PostEntry -> PostEntry -> Order
--postPublishDateDescending ( _, metadata1 ) ( _, metadata2 ) =
--    Date.compare metadata2.published metadata1.published
--postSummary : PostEntry -> Element msg
--postSummary ( postPath, post ) =
--    articleIndex post
--        |> linkToPost postPath
--
--
--linkToPost : PagePath Pages.PathKey -> Element msg -> Element msg
--linkToPost postPath content =
--    Element.link [ Element.width Element.fill ]
--        { url = PagePath.toString postPath, label = content }
--
--
--title : String -> Element msg
--title text =
--    [ Element.text text ]
--        |> Element.paragraph
--            [ Element.Font.size 36
--            , Element.Font.center
--            , Element.Font.family [ Element.Font.typeface "Raleway" ]
--            , Element.Font.semiBold
--            , Element.padding 16
--            ]
--
--
--articleIndex : Metadata.EpisodeData -> Element msg
--articleIndex metadata =
--    Element.el
--        [ Element.centerX
--        , Element.width (Element.maximum 800 Element.fill)
--        , Element.padding 40
--        , Element.spacing 10
--        , Element.Border.width 1
--        , Element.Border.color (Element.rgba255 0 0 0 0.1)
--        , Element.mouseOver
--            [ Element.Border.color (Element.rgba255 0 0 0 1)
--            ]
--        ]
--        (postPreview metadata)
--
--
--readMoreLink =
--    Element.text "Continue reading >>"
--        |> Element.el
--            [ Element.centerX
--            , Element.Font.size 18
--            , Element.alpha 0.6
--            , Element.mouseOver [ Element.alpha 1 ]
--            , Element.Font.underline
--            , Element.Font.center
--            ]
--
--
--postPreview : Metadata.EpisodeData -> Element msg
--postPreview post =
--    Element.textColumn
--        [ Element.centerX
--        , Element.width Element.fill
--        , Element.spacing 30
--        , Element.Font.size 18
--        ]
--        [ title post.title
--        , Element.row [ Element.spacing 10, Element.centerX ]
--            [ --Data.Author.view [ Element.width (Element.px 40) ] post.author
--              --Element.text post.author.name
--              Element.text "•"
--
--            --, Element.text (post.published |> Date.format "MMMM ddd, yyyy")
--            ]
--        , post.description
--            |> Element.text
--            |> List.singleton
--            |> Element.paragraph
--                [ Element.Font.size 22
--                , Element.Font.center
--                , Element.Font.family [ Element.Font.typeface "Raleway" ]
--                ]
--        , readMoreLink
--        ]
