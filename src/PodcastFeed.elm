module PodcastFeed exposing (buildFeed, generate)

import Dict exposing (Dict)
import Html exposing (..)
import Json.Decode.Exploration as Decode exposing (Decoder)
import Metadata exposing (Metadata)
import Pages
import Pages.PagePath exposing (PagePath)
import Pages.Secrets as Secrets
import Pages.StaticHttp as StaticHttp
import Regex exposing (Regex)


generate :
    List
        { path : PagePath Pages.PathKey
        , frontmatter : Metadata
        , body : String
        }
    ->
        StaticHttp.Request
            (List
                (Result String
                    { path : List String
                    , content : String
                    }
                )
            )
generate siteMetadata =
    siteMetadata
        |> List.filterMap
            (\{ frontmatter } ->
                case frontmatter of
                    Metadata.Episode episodeData ->
                        request episodeData
                            |> Just

                    _ ->
                        Nothing
            )
        |> StaticHttp.combine
        |> StaticHttp.map
            (\episodes ->
                [ Ok
                    { path = [ "feed.xml" ]
                    , content = buildFeed episodes
                    }
                ]
            )


request : Metadata.EpisodeData -> StaticHttp.Request Episode
request episodeData =
    StaticHttp.request
        (Secrets.succeed
            (\simplecastToken ->
                { method = "GET"
                , url = "https://api.simplecast.com/episodes/" ++ episodeData.simplecastId
                , headers = [ ( "Authorization", "Bearer " ++ simplecastToken ) ]
                , body = StaticHttp.emptyBody
                }
            )
            |> Secrets.with "SIMPLECAST_TOKEN"
        )
        (episodeDecoder episodeData)


type alias Episode =
    { title : String
    , duration : Int
    , number : Int
    , description : String
    , guid : String
    , audio :
        { url : String
        , sizeInBytes : Int
        }
    }


episodeDecoder : Metadata.EpisodeData -> Decoder Episode
episodeDecoder episodeData =
    Decode.map6 Episode
        (Decode.succeed episodeData.title)
        (Decode.field "duration" Decode.int)
        (Decode.field "number" Decode.int)
        (Decode.succeed episodeData.description)
        (Decode.succeed episodeData.simplecastId)
        (Decode.field "audio_file"
            (Decode.map2 (\url sizeInBytes -> { url = url, sizeInBytes = sizeInBytes })
                (Decode.field "url" Decode.string)
                (Decode.field "size" Decode.int)
            )
        )


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
                        |> List.map itemToString
                        |> String.join "\n"
                  )
                , ( "lastBuiltAt", "Fri, 3 Apr 2020 15:18:06 +0000" )
                ]
            )


itemToString : Episode -> String
itemToString episode =
    """<item>
    <guid isPermaLink="false">{{guid}}</guid>
    <title>{{title}}</title>
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
                , ( "number", episode.number |> String.fromInt )
                , ( "duration", episode.duration |> String.fromInt )
                , ( "audioUrl", episode.audio.url )
                , ( "guid", episode.guid )
                , ( "pubDate", "Fri, 3 Apr 2020 15:12:18 +0000" ) -- TODO
                , ( "link", "https://elm-radio.com/intro-to-opaque-types" ) -- TODO
                , ( "sizeInBytes", episode.audio.sizeInBytes |> String.fromInt )

                -- TODO render show notes
                , ( "showNotesHtml", """<h2>Opaque Types</h2><p>Some patterns</p><ul><li>Runtime validations - conditionally return type, wrapped in Result or Maybe</li><li>Guarantee constraints through the exposed API of the module (like PositiveInteger or AuthToken examples)</li></ul><h2>Package-Opaque Modules</h2><p>Example - the <a href="https://package.elm-lang.org/packages/mdgriffith/elm-ui/latest/Element#Element">Element</a> type in elm-ui.<br />Definition of the <a href="https://github.com/mdgriffith/elm-ui/blob/53a2732d9533c242c7690e16506b673af982032a/src/Element.elm#L325-L326">Element type alias</a></p><p><a href="https://github.com/mdgriffith/elm-ui/blob/1.1.5/elm.json#L7-L17">elm-ui's elm.json file</a> does not expose the internal module where the real Element type is defined.</p><p>Example from <a href="https://github.com/dillonkearns/elm-graphql">elm-graphql</a> codebase - <a href="https://github.com/dillonkearns/elm-graphql/blob/master/generator/src/Graphql/Parser/CamelCaseName.elm">CamelCaseName opaque type</a></p>
""" )
                ]
            )


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
