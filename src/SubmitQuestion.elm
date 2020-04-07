module SubmitQuestion exposing (..)

import Html exposing (..)
import Html.Attributes as Attr exposing (class)


view =
    [ div [ class "flex flex-grow flex-col pt-6 px-4" ]
        [ div [ class "" ]
            [ div [ class "flex justify-between" ]
                [ label [ class "block text-sm font-medium leading-5 text-dark", Attr.for "name" ]
                    [ text "Your Name" ]
                , span [ class "text-sm leading-5 text-gray-500" ]
                    [ text "Optional" ]
                ]
            , div [ class "mt-1 relative rounded-md shadow-sm" ]
                [ input [ class "form-input block w-full sm:text-sm sm:leading-5", Attr.id "name", Attr.placeholder "Jane Doe" ]
                    []
                , text "  "
                ]
            ]
        , div []
            [ div [ class "flex justify-between" ]
                [ label [ class "block text-sm font-medium leading-5 text-dark", Attr.for "question" ]
                    [ text "Your Question" ]
                ]
            , div [ class "mt-1 relative rounded-md shadow-sm" ]
                [ input [ class "form-input block w-full sm:text-sm sm:leading-5", Attr.id "question", Attr.placeholder "How do you decode JSON into a custom type?" ]
                    []
                , text "  "
                ]
            ]
        ]
    ]
