module Data.Transcript exposing (..)

import BackendTask exposing (BackendTask)
import BackendTask.File
import BackendTask.Glob as Glob
import Episode
import Episode2 exposing (EpisodeData)
import FatalError exposing (FatalError)
import Json.Decode as Decode exposing (Decoder)
import Json.Encode as Encode
import Markdown.Block exposing (Block)


type alias Segment =
    { start : Float
    , end : Float
    , text : String
    }


type alias SubData =
    { metadata : EpisodeData
    , renderedBody : List Block
    }


data : String -> BackendTask FatalError ( Episode.Episode, Bool )
data slug =
    Episode.cachedLookupWithMetadata slug
        |> BackendTask.andThen
            (\subData ->
                BackendTask.map2 Tuple.pair
                    (BackendTask.succeed subData)
                    (checkTranscriptExists subData)
            )


transcriptData : { episode | number : Int } -> BackendTask FatalError (Maybe (List Segment))
transcriptData episode =
    let
        fileName : String
        fileName =
            transcriptFilePath episode
    in
    checkTranscriptExists episode
        |> BackendTask.andThen
            (\transcriptExists ->
                if transcriptExists then
                    fileName
                        |> BackendTask.File.jsonFile transcriptDecoder
                        |> BackendTask.allowFatal
                        |> BackendTask.map Just

                else
                    BackendTask.succeed Nothing
            )


checkTranscriptExists : { episode | number : Int } -> BackendTask FatalError Bool
checkTranscriptExists episode =
    let
        fileName : String
        fileName =
            transcriptFilePath episode
    in
    Glob.literal fileName
        |> Glob.toBackendTask
        |> BackendTask.map (\list -> List.length list > 0)


transcriptFilePath : { episode | number : Int } -> String
transcriptFilePath episode =
    let
        paddedNumber : String
        paddedNumber =
            String.fromInt episode.number
                |> String.padLeft 3 '0'

        fileName : String
        fileName =
            "transcripts/" ++ paddedNumber ++ "/" ++ paddedNumber ++ ".json"
    in
    fileName


transcriptDecoder : Decoder (List Segment)
transcriptDecoder =
    Decode.field "segments"
        (Decode.list
            (Decode.map3 Segment
                (Decode.field "start" Decode.float)
                (Decode.field "end" Decode.float)
                (Decode.field "text" Decode.string)
            )
        )


needTranscript : BackendTask FatalError String
needTranscript =
    Episode.slugs
        |> BackendTask.andThen
            (\slugs ->
                slugs
                    |> List.map data
                    |> BackendTask.combine
                    |> BackendTask.map
                        (\items ->
                            items
                                |> List.filterMap
                                    (\( episode, hasTranscript ) ->
                                        if hasTranscript then
                                            Nothing

                                        else
                                            Encode.object
                                                [ ( "number", Encode.int episode.number )
                                                , ( "title", Encode.string episode.title )
                                                , ( "url", Encode.string episode.audio.url )
                                                ]
                                                |> Just
                                    )
                                |> Encode.list identity
                                |> Encode.encode 0
                        )
            )
