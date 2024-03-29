module PodcastFeed exposing (PublishDate(..), generate)

import BackendTask exposing (BackendTask)
import BackendTask.Custom
import BackendTask.Env as Env
import BackendTask.File
import BackendTask.Glob as Glob
import BackendTask.Http
import Dict exposing (Dict)
import Episode2
import FatalError exposing (FatalError)
import HtmlStringMarkdownRenderer
import Imf.DateTime as Imf
import Iso8601
import Json.Decode as Decode exposing (Decoder)
import Json.Encode
import Pages
import Pages.Script as Script
import Path
import Regex exposing (Regex)
import Route exposing (Route)
import Time


generate : BackendTask FatalError String
generate =
    Episode2.episodes
        |> BackendTask.map (List.map (\record -> request (Tuple.first record.other) (Tuple.second record.other) record.rawBody))
        |> BackendTask.resolve
        |> BackendTask.map
            (\episodes -> buildFeed episodes)


cachedLookup : Route -> Episode2.EpisodeData -> String -> BackendTask FatalError Episode
cachedLookup route episodeData body =
    let
        filePath : String
        filePath =
            "simplecast-cache/" ++ String.fromInt episodeData.number ++ ".json"
    in
    Glob.literal filePath
        |> Glob.toBackendTask
        |> BackendTask.allowFatal
        |> BackendTask.andThen
            (\matchingFiles ->
                if matchingFiles |> List.isEmpty then
                    (Env.expect "SIMPLECAST_TOKEN"
                        |> BackendTask.allowFatal
                        |> BackendTask.andThen
                            (\simplecastToken ->
                                BackendTask.Http.getWithOptions
                                    { url = "https://api.simplecast.com/episodes/" ++ episodeData.simplecastId
                                    , headers = [ ( "Authorization", "Bearer " ++ simplecastToken ) ]
                                    , expect =
                                        BackendTask.Http.expectJson
                                            (Decode.map2 Tuple.pair Decode.value (episodeDecoder route episodeData body))
                                    , timeoutInMs = Nothing
                                    , retries = Nothing
                                    , cacheStrategy = Nothing
                                    , cachePath = Nothing
                                    }
                                    |> BackendTask.allowFatal
                            )
                    )
                        |> BackendTask.andThen
                            (\( rawJson, decoded ) ->
                                writeFile
                                    filePath
                                    (Json.Encode.encode 0 rawJson)
                                    |> BackendTask.map (\() -> decoded)
                            )

                else
                    BackendTask.File.jsonFile
                        (episodeDecoder route episodeData body)
                        filePath
                        |> BackendTask.allowFatal
            )


writeFile : String -> String -> BackendTask FatalError ()
writeFile filePath body =
    Script.writeFile
        { path = filePath
        , body = body
        }
        |> BackendTask.allowFatal


request : Route -> Episode2.EpisodeData -> String -> BackendTask FatalError Episode
request route episodeData body =
    cachedLookup route episodeData body


type alias Episode =
    { title : String
    , description : String
    , guid : String
    , route : Route
    , publishAt : PublishDate
    , duration : Int
    , number : Int
    , audio :
        { url : String
        , sizeInBytes : Int
        }
    , showNotesHtml : String
    }


episodeDecoder : Route -> Episode2.EpisodeData -> String -> Decoder Episode
episodeDecoder path episodeData body =
    Decode.map5
        (Episode episodeData.title episodeData.description episodeData.simplecastId path)
        scheduledOrPublishedTime
        (Decode.field "duration" Decode.int)
        (Decode.field "number" Decode.int)
        (Decode.field "audio_file"
            (Decode.map2 (\url sizeInBytes -> { url = url, sizeInBytes = sizeInBytes })
                (Decode.field "url" Decode.string)
                (Decode.field "size" Decode.int)
            )
        )
        (bodyDecoder body)


type PublishDate
    = Scheduled Time.Posix
    | Published Time.Posix


scheduledOrPublishedTime : Decoder PublishDate
scheduledOrPublishedTime =
    Decode.oneOf
        [ Decode.field "scheduled_for" iso8601Decoder
        , Decode.field "published_at" iso8601Decoder
        ]
        |> Decode.map
            (\time ->
                if Time.posixToMillis time > Time.posixToMillis Pages.builtAt then
                    Scheduled time

                else
                    Published time
            )


iso8601Decoder =
    Decode.string
        |> Decode.andThen
            (\datetimeString ->
                case Iso8601.toTime datetimeString of
                    Ok time ->
                        Decode.succeed time

                    Err _ ->
                        Decode.fail "Could not parse datetime."
            )



{-
   "is_published": true,
   "audio_file_size": 38663872,
   "enclosure_url": "https://cdn.simplecast.com/audio/6a206b/6a206baa-9c8e-4c25-9037-2b674204ba84/fcdfee63-05b5-49af-b854-da4b814b98e6/002-intro-to-opaque-types_tc.mp3",
   "status": "published",
   "audio_content_type": "audio/mpeg",
   "publish": null,
   "published_at": "2020-04-03T08:12:18-07:00",
-}
{-
   "scheduled_for": "2020-10-05T05:00:00-07:00",
-}


bodyDecoder : String -> Decoder String
bodyDecoder body =
    case HtmlStringMarkdownRenderer.renderMarkdown body of
        Ok renderedBody ->
            Decode.succeed renderedBody

        Err error ->
            Decode.fail error


buildFeed : List Episode -> String
buildFeed episodes =
    """<?xml version="1.0" encoding="UTF-8"?>
<rss version="2.0" xmlns:atom="http://www.w3.org/2005/Atom" xmlns:content="http://purl.org/rss/1.0/modules/content/" xmlns:googleplay="http://www.google.com/schemas/play-podcasts/1.0" xmlns:itunes="http://www.itunes.com/dtds/podcast-1.0.dtd">
  <channel>
    <atom:link href="https://elm-radio.com/feed.xml" rel="self" title="MP3 Audio" type="application/atom+xml"/>
    <atom:link href="https://pubsubhubbub.appspot.com/" rel="hub" xmlns="http://www.w3.org/2005/Atom"/>
    <generator>https://elm-pages.com</generator>
    <title>Elm Radio</title>
    <description>Tune in to the tools and techniques in the Elm ecosystem.</description>
    <copyright>2020 Elm Radio</copyright>
    <language>en</language>
    <pubDate>{{lastBuiltAt}}</pubDate>
    <lastBuildDate>{{lastBuiltAt}}</lastBuildDate>
    <image>
      <link>https://elm-radio.com</link>
      <title>Elm Radio</title>
      <url>https://cdn.simplecast.com/images/9c2e375f-5f18-41e3-a00b-7a46ccbe2d20/3411a1cf-55a7-4d9d-949c-c529749259e7/3000x3000/podcast-cover-art.jpg?aid=rss_feed</url>
    </image>
    <link>https://elm-radio.com</link>
    <itunes:type>episodic</itunes:type>
    <itunes:summary>Tune in to the tools and techniques in the Elm ecosystem.</itunes:summary>
    <itunes:author>Dillon Kearns, Jeroen Engels</itunes:author>
    <itunes:explicit>no</itunes:explicit>
    <itunes:image href="https://cdn.simplecast.com/images/9c2e375f-5f18-41e3-a00b-7a46ccbe2d20/3411a1cf-55a7-4d9d-949c-c529749259e7/3000x3000/podcast-cover-art.jpg?aid=rss_feed"/>
    <itunes:new-feed-url>https://elm-radio.com/feed.xml</itunes:new-feed-url>
    <itunes:keywords>elm, web-development, functional-programming, programming, jamstack</itunes:keywords>
    <itunes:owner>
      <itunes:name>Dillon Kearns</itunes:name>
      <itunes:email>dillon@incrementalelm.com</itunes:email>
    </itunes:owner>
    <itunes:category text="Technology"/>
    {{items}}
  </channel>
</rss>
    """
        |> replaceTemplateVars
            (Dict.fromList
                [ ( "items"
                  , episodes
                        |> List.sortBy (\episode -> -episode.number)
                        |> List.filterMap itemToString
                        |> String.join "\n"
                  )
                , ( "lastBuiltAt"
                  , Pages.builtAt |> Imf.fromPosix Time.utc
                    --"Fri, 3 Apr 2020 15:18:06 +0000"
                  )
                ]
            )


itemToString : Episode -> Maybe String
itemToString episode =
    case episode.publishAt of
        Scheduled _ ->
            Nothing

        Published publishTime ->
            """<item>
    <guid isPermaLink="false">{{guid}}</guid>
    <title>{{titleWithNumber}}</title>
    <description>
    <![CDATA[{{showNotesHtml}}]]>
    </description>
    <pubDate>{{pubDate}}</pubDate>
    <author>dillon@incrementalelm.com (Dillon Kearns)</author>
    <link>{{link}}</link>
    <content:encoded>
    <![CDATA[{{showNotesHtml}}]]>
    </content:encoded>
    <enclosure length="{{sizeInBytes}}" type="audio/mpeg" url="{{audioUrl}}"/>
    <itunes:title>{{title}}</itunes:title>
    <itunes:author>Dillon Kearns</itunes:author>
    <itunes:duration>{{duration}}</itunes:duration>
    <itunes:summary>{{description}}</itunes:summary>
    <itunes:subtitle>{{description}}</itunes:subtitle>
    <itunes:explicit>no</itunes:explicit>
    <itunes:episodeType>full</itunes:episodeType>
    <itunes:episode>{{number}}</itunes:episode>
</item>"""
                |> replaceTemplateVars
                    (Dict.fromList
                        [ ( "description", episode.description )
                        , ( "title", episode.title )
                        , ( "titleWithNumber", titleWithNumber episode.number episode.title )
                        , ( "number", episode.number |> String.fromInt )
                        , ( "duration", episode.duration |> String.fromInt )
                        , ( "audioUrl", episode.audio.url )
                        , ( "guid", episode.guid )
                        , ( "pubDate"
                          , publishTime |> Imf.fromPosix Time.utc
                          )

                        --"Fri, 3 Apr 2020 15:12:18 +0000"
                        , ( "link", "https://elm-radio.com" ++ Path.toAbsolute (Route.toPath episode.route) )
                        , ( "sizeInBytes", episode.audio.sizeInBytes |> String.fromInt )
                        , ( "showNotesHtml", episode.showNotesHtml )
                        ]
                    )
                |> Just


titleWithNumber : Int -> String -> String
titleWithNumber number title =
    String.concat
        [ String.padLeft 3 '0' (String.fromInt number)
        , ": "
        , title
        ]


replaceTemplateVars : Dict String String -> String -> String
replaceTemplateVars dict input =
    input
        |> Regex.replace templateRegex
            (\match ->
                case match.submatches of
                    [ Just templateVariableName ] ->
                        dict
                            |> Dict.get templateVariableName
                            |> Maybe.withDefault "<<<<<NOT FOUND>>>>>"

                    _ ->
                        "<<<<<NOT FOUND>>>>>"
            )


templateRegex : Regex
templateRegex =
    Regex.fromString "\\{\\{([^}]*)}}"
        |> Maybe.withDefault Regex.never
