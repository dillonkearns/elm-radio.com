module Episode2 exposing (..)

import BackendTask exposing (BackendTask)
import BackendTask.File
import BackendTask.Glob as Glob
import Episode
import FatalError exposing (FatalError)
import Json.Decode as Decode exposing (Decoder)
import Route exposing (Route)


data : BackendTask FatalError (List Episode.Episode)
data =
    episodes
        |> BackendTask.andThen
            (\resolvedEpisodes ->
                resolvedEpisodes
                    |> List.map .other
                    |> List.map (\( route, info ) -> Episode.episodeRequest route info)
                    |> BackendTask.combine
            )


episodes : BackendTask FatalError (List FullThing)
episodes =
    Glob.succeed
        (\name ->
            let
                filePath : String
                filePath =
                    "content/episode/" ++ name ++ ".md"
            in
            BackendTask.map2 FullThing
                (BackendTask.File.bodyWithoutFrontmatter filePath)
                (BackendTask.map
                    (Tuple.pair (Route.Episode__Name_ { name = name }))
                    (BackendTask.File.onlyFrontmatter episodeDecoder filePath)
                )
        )
        |> Glob.match (Glob.literal "content/episode/")
        |> Glob.capture Glob.wildcard
        |> Glob.match (Glob.literal ".md")
        |> Glob.toBackendTask
        |> BackendTask.resolve
        |> BackendTask.allowFatal


type alias FullThing =
    { rawBody : String, other : ( Route, EpisodeData ) }


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
