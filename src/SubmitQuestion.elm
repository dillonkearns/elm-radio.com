module SubmitQuestion exposing (..)

import Html exposing (..)
import Html.Attributes as Attr exposing (class)


view =
    [ form
        [ Attr.name "question"
        , Attr.method "POST"
        , Attr.attribute "data-netlify" "true"
        , Attr.action "/#thanks-for-the-question"
        , class "flex flex-grow flex-col pt-6 px-4"
        ]
        [ div [ class "" ]
            [ div [ class "flex justify-between" ]
                [ label [ class "block text-sm font-medium leading-5 text-dark", Attr.for "name" ]
                    [ text "Your Name" ]
                , span [ class "text-sm leading-5 text-gray-500" ]
                    [ text "Optional" ]
                ]
            , div [ class "mt-1 relative rounded-md shadow-sm" ]
                [ input
                    [ class "form-input block w-full sm:text-sm sm:leading-5"
                    , Attr.name "name"
                    , Attr.id "name"
                    , Attr.placeholder "Jane Doe"
                    ]
                    []
                , text "  "
                ]
            ]
        , div [ class "mt-2" ]
            [ div [ class "flex justify-between" ]
                [ label [ class "block text-sm font-medium leading-5 text-dark", Attr.for "question" ]
                    [ text "Your Question" ]
                ]
            , div [ class "mt-1 relative rounded-md shadow-sm" ]
                [ textarea
                    [ class "form-input block w-full sm:text-sm sm:leading-5"
                    , Attr.name "question"
                    , Attr.id "question"
                    , Attr.placeholder "How do you decode JSON into a custom type?"
                    ]
                    []
                , text "  "
                ]
            ]
        , button
            [ Attr.type_ "submit"
            , class "rounded-lg mt-8 w-full py-2 px-4 text-xl font-semibold border-2 shadow-lg bg-white border-dark"
            ]
            [ text "Submit Question"
            ]

        --, button [ class "rounded-lg mt-8 w-full py-2 px-4 text-xl font-semibold border-2 shadow-lg bg-white border-dark" ]
        --    [ text "Submit Question"
        --    ]
        ]
    ]
