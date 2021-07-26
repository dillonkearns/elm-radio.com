module Episode2 exposing (..)

import DataSource exposing (DataSource)
import DataSource.File
import DataSource.Glob as Glob
import Episode
import OptimizedDecoder as Decode exposing (Decoder)
import Path exposing (Path)
import Route


data : DataSource (List Episode.Episode)
data =
    episodes
        |> DataSource.andThen
            (\resolvedEpisodes ->
                resolvedEpisodes
                    |> List.map .other
                    |> List.map (\( path, info ) -> Episode.episodeRequest path info)
                    |> DataSource.combine
            )


episodes : DataSource (List { rawBody : String, other : ( Path, EpisodeData ) })
episodes =
    Glob.succeed
        (\name ->
            let
                filePath : String
                filePath =
                    "content/episode/" ++ name ++ ".md"
            in
            DataSource.map2 FullThing
                (DataSource.File.bodyWithoutFrontmatter filePath)
                (DataSource.map
                    (Tuple.pair (Route.Episode__Name_ { name = name } |> Route.toPath))
                    (DataSource.File.onlyFrontmatter episodeDecoder filePath)
                )
        )
        |> Glob.match (Glob.literal "content/episode/")
        |> Glob.capture Glob.wildcard
        |> Glob.match (Glob.literal ".md")
        |> Glob.toDataSource
        |> DataSource.resolve


type alias FullThing =
    { rawBody : String, other : ( Path, EpisodeData ) }


type alias EpisodeData =
    { number : Int
    , title : String
    , description : String
    , simplecastId : String
    }


episodeDecoder : Decoder EpisodeData
episodeDecoder =
    Decode.map4 EpisodeData
        (Decode.field "number" Decode.int)
        (Decode.field "title" Decode.string)
        (Decode.field "description" Decode.string)
        (Decode.field "simplecastId" Decode.string)
