module Metadata exposing (EpisodeData, Metadata(..), PageMetadata, decoder)

import Json.Decode as Decode exposing (Decoder)
import List.Extra
import Pages
import Pages.ImagePath as ImagePath exposing (ImagePath)


type Metadata
    = Page PageMetadata
    | EpisodeIndex
    | Episode EpisodeData


type alias PageMetadata =
    { title : String }


type alias EpisodeData =
    { number : Int
    , title : String
    , description : String
    , simplecastId : String
    }


decoder : Decoder Metadata
decoder =
    Decode.field "type" Decode.string
        |> Decode.andThen
            (\pageType ->
                case pageType of
                    "episode-index" ->
                        Decode.succeed EpisodeIndex

                    "episode" ->
                        episodeDecoder
                            |> Decode.map Episode

                    "page" ->
                        Decode.map PageMetadata
                            (Decode.field "title" Decode.string)
                            |> Decode.map Page

                    _ ->
                        Decode.fail <| "Unexpected page type " ++ pageType
            )


episodeDecoder : Decoder EpisodeData
episodeDecoder =
    Decode.map4 EpisodeData
        (Decode.field "number" Decode.int)
        (Decode.field "title" Decode.string)
        (Decode.field "description" Decode.string)
        (Decode.field "simplecastId" Decode.string)


imageDecoder : Decoder (ImagePath Pages.PathKey)
imageDecoder =
    Decode.string
        |> Decode.andThen
            (\imageAssetPath ->
                case findMatchingImage imageAssetPath of
                    Nothing ->
                        Decode.fail "Couldn't find image."

                    Just imagePath ->
                        Decode.succeed imagePath
            )


findMatchingImage : String -> Maybe (ImagePath Pages.PathKey)
findMatchingImage imageAssetPath =
    Pages.allImages
        |> List.Extra.find
            (\image ->
                ImagePath.toString image
                    == imageAssetPath
            )
