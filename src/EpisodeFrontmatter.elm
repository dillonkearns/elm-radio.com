module EpisodeFrontmatter exposing (..)

import DataSource exposing (DataSource)
import DataSource.File
import DataSource.Glob as Glob
import OptimizedDecoder as Decode exposing (Decoder)
import Route exposing (Route)


episodes : DataSource (List ( Route, Data ))
episodes =
    Glob.succeed
        (\name ->
            DataSource.map
                (Tuple.pair (Route.Episode__Name_ { name = name }))
                (DataSource.File.onlyFrontmatter episodeDecoder ("content/episode/" ++ name ++ ".md"))
        )
        |> Glob.match (Glob.literal "content/episode/")
        |> Glob.capture Glob.wildcard
        |> Glob.match (Glob.literal ".md")
        |> Glob.toDataSource
        |> DataSource.resolve


type alias Data =
    { number : Int
    , title : String
    , description : String
    , simplecastId : String
    }


episodeDecoder : Decoder Data
episodeDecoder =
    Decode.map4 Data
        (Decode.field "number" Decode.int)
        (Decode.field "title" Decode.string)
        (Decode.field "description" Decode.string)
        (Decode.field "simplecastId" Decode.string)
