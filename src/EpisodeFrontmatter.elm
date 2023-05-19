module EpisodeFrontmatter exposing (..)

import BackendTask exposing (BackendTask)
import BackendTask.File
import BackendTask.Glob as Glob
import FatalError exposing (FatalError)
import Json.Decode as Decode exposing (Decoder)
import Route exposing (Route)


episodes : BackendTask FatalError (List ( Route, Data ))
episodes =
    Glob.succeed
        (\name ->
            BackendTask.map
                (Tuple.pair (Route.Episode__Name_ { name = name }))
                (BackendTask.File.onlyFrontmatter episodeDecoder ("content/episode/" ++ name ++ ".md"))
        )
        |> Glob.match (Glob.literal "content/episode/")
        |> Glob.capture Glob.wildcard
        |> Glob.match (Glob.literal ".md")
        |> Glob.toBackendTask
        |> BackendTask.resolve
        |> BackendTask.allowFatal


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
