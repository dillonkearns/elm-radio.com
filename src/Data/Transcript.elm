module Data.Transcript exposing (..)

import DataSource exposing (DataSource)
import DataSource.File
import DataSource.Glob as Glob
import Episode
import Episode2 exposing (EpisodeData)
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


data : String -> DataSource ( Episode.Episode, Bool )
data slug =
    Episode.cachedLookupWithMetadata slug
        |> DataSource.andThen
            (\subData ->
                DataSource.map2 Tuple.pair
                    (DataSource.succeed subData)
                    (checkTranscriptExists subData)
            )


transcriptData : { episode | number : Int } -> DataSource (Maybe (List Segment))
transcriptData episode =
    let
        fileName : String
        fileName =
            transcriptFilePath episode
    in
    checkTranscriptExists episode
        |> DataSource.andThen
            (\transcriptExists ->
                if transcriptExists then
                    fileName
                        |> DataSource.File.jsonFile transcriptDecoder
                        |> DataSource.map Just

                else
                    DataSource.succeed Nothing
            )


checkTranscriptExists : { episode | number : Int } -> DataSource Bool
checkTranscriptExists episode =
    let
        fileName : String
        fileName =
            transcriptFilePath episode
    in
    Glob.literal fileName
        |> Glob.toDataSource
        |> DataSource.map (\list -> List.length list > 0)


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


needTranscript : DataSource String
needTranscript =
    Episode.slugs
        |> DataSource.andThen
            (\slugs ->
                slugs
                    |> List.map data
                    |> DataSource.combine
                    |> DataSource.map
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
