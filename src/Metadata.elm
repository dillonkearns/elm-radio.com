module Metadata exposing (EpisodeData, Metadata(..), PageMetadata, decoder)

import Iso8601
import Json.Decode as Decode exposing (Decoder)
import List.Extra
import Pages
import Pages.ImagePath as ImagePath exposing (ImagePath)
import Time


type Metadata
    = Page PageMetadata
    | Episode EpisodeData


type alias PageMetadata =
    { title : String }


type alias EpisodeData =
    { number : Int
    , title : String
    , description : String
    , simplecastId : String
    , publishAt : Time.Posix
    }


decoder : Decoder Metadata
decoder =
    Decode.field "type" Decode.string
        |> Decode.andThen
            (\pageType ->
                case pageType of
                    "page" ->
                        Decode.field "title" Decode.string
                            |> Decode.map (\title -> Page { title = title })

                    "episode" ->
                        episodeDecoder
                            |> Decode.map Episode

                    _ ->
                        Decode.fail <| "Unexpected page type " ++ pageType
            )


episodeDecoder : Decoder EpisodeData
episodeDecoder =
    Decode.map5 EpisodeData
        (Decode.field "number" Decode.int)
        (Decode.field "title" Decode.string)
        (Decode.field "description" Decode.string)
        (Decode.field "simplecastId" Decode.string)
        (Decode.field "publishAt" Iso8601.decoder)


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
