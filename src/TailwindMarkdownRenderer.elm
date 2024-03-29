module TailwindMarkdownRenderer exposing (renderer)

import Html exposing (Html)
import Html.Attributes as Attr exposing (class)
import Markdown.Block as Block
import Markdown.Html
import Markdown.Renderer


renderer : Markdown.Renderer.Renderer (Html msg)
renderer =
    { heading =
        \{ level, children } ->
            case level of
                Block.H1 ->
                    Html.h1 [ class "font-display" ] children

                Block.H2 ->
                    Html.h2 [ class "text-3xl font-display" ] children

                Block.H3 ->
                    Html.h3 [ class "text-2xl font-display" ] children

                _ ->
                    Html.h4 [ class "font-display" ] children
    , paragraph = Html.p [ class "mb-4" ]
    , hardLineBreak = Html.br [] []
    , blockQuote = Html.blockquote [ class "p-0 p-2 mx-6 bg-gray mb-4 border-l-4 border-gray italic" ]
    , strong =
        \children -> Html.strong [ class "font-bold" ] children
    , emphasis =
        \children -> Html.em [ class "italic" ] children
    , strikethrough =
        \children -> Html.strong [ class "line-through" ] children
    , codeSpan =
        \content -> Html.code [] [ Html.text content ]
    , link =
        \link content ->
            case link.title of
                Just title ->
                    Html.a
                        [ Attr.href link.destination
                        , Attr.title title
                        , class "hover:underline text-highlight"
                        , Attr.style "overflow-wrap" "anywhere"
                        ]
                        content

                Nothing ->
                    Html.a
                        [ Attr.href link.destination
                        , class "hover:underline text-highlight"
                        , Attr.style "overflow-wrap" "anywhere"
                        ]
                        content
    , image =
        \imageInfo ->
            case imageInfo.title of
                Just title ->
                    Html.img
                        [ Attr.src imageInfo.src
                        , Attr.alt imageInfo.alt
                        , Attr.title title
                        ]
                        []

                Nothing ->
                    Html.img
                        [ Attr.src imageInfo.src
                        , Attr.alt imageInfo.alt
                        ]
                        []
    , text =
        Html.text
    , unorderedList =
        \items ->
            Html.ul [ class "list-disc ml-4" ]
                (items
                    |> List.map
                        (\item ->
                            case item of
                                Block.ListItem task children ->
                                    let
                                        checkbox =
                                            case task of
                                                Block.NoTask ->
                                                    Html.text ""

                                                Block.IncompleteTask ->
                                                    Html.input
                                                        [ Attr.disabled True
                                                        , Attr.checked False
                                                        , Attr.type_ "checkbox"
                                                        ]
                                                        []

                                                Block.CompletedTask ->
                                                    Html.input
                                                        [ Attr.disabled True
                                                        , Attr.checked True
                                                        , Attr.type_ "checkbox"
                                                        ]
                                                        []
                                    in
                                    Html.li [] (checkbox :: children)
                        )
                )
    , orderedList =
        \startingIndex items ->
            Html.ol
                (if startingIndex /= 1 then
                    [ Attr.start startingIndex
                    , class "mb-4 ml-8"
                    , Attr.style "list-style" "decimal"
                    ]

                 else
                    [ class "mb-4 ml-8"
                    , Attr.style "list-style" "decimal"
                    ]
                )
                (items
                    |> List.map
                        (\itemBlocks ->
                            Html.li []
                                itemBlocks
                        )
                )
    , html =
        Markdown.Html.oneOf []
    , codeBlock =
        \{ body } ->
            Html.div []
                [ Html.code []
                    [ Html.text body
                    ]
                ]
    , thematicBreak = Html.hr [] []
    , table = Html.table []
    , tableHeader = Html.thead []
    , tableBody = Html.tbody []
    , tableRow = Html.tr []
    , tableHeaderCell =
        \maybeAlignment ->
            let
                attrs =
                    maybeAlignment
                        |> Maybe.map
                            (\alignment ->
                                case alignment of
                                    Block.AlignLeft ->
                                        "left"

                                    Block.AlignCenter ->
                                        "center"

                                    Block.AlignRight ->
                                        "right"
                            )
                        |> Maybe.map Attr.align
                        |> Maybe.map List.singleton
                        |> Maybe.withDefault []
            in
            Html.th attrs
    , tableCell = \_ -> Html.td []
    }



--|> Result.map (List.map (Html.toString 0))
--|> Result.map (String.join "")
--htmlRenderer : Markdown.Html.Renderer (List (Html.Html msg) -> Html.Html msg)
--htmlRenderer =
--passthrough
--    (\tag attributes blocks ->
--        let
--            result : Result String (List (Html.Html msg) -> Html.Html msg)
--            result =
--                (\children ->
--                    Html.node tag htmlAttributes children
--                )
--                    |> Ok
--
--            htmlAttributes : List (Html.Attribute msg)
--            htmlAttributes =
--                attributes
--                    |> List.map
--                        (\{ name, value } ->
--                            Attr.attribute name value
--                        )
--        in
--        result
--    )
--{-| TODO come up with an API to provide a solution to do this sort of thing publicly
---}
--passthrough : (String -> List Markdown.HtmlRenderer.Attribute -> List Block -> Result String view) -> Markdown.HtmlRenderer.HtmlRenderer view
--passthrough renderFn =
--    Markdown.HtmlRenderer.HtmlRenderer renderFn
