module PodcastFeed exposing (buildFeed, generate)

import Dict exposing (Dict)
import HtmlStringMarkdownRenderer
import Imf.DateTime as Imf
import Metadata exposing (Metadata)
import OptimizedDecoder as Decode exposing (Decoder)
import Pages
import Pages.PagePath as PagePath exposing (PagePath)
import Pages.Secrets as Secrets
import Pages.StaticHttp as StaticHttp
import Regex exposing (Regex)
import Time


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
            (\{ path, frontmatter, body } ->
                case frontmatter of
                    Metadata.Episode episodeData ->
                        request path episodeData body
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


request : PagePath Pages.PathKey -> Metadata.EpisodeData -> String -> StaticHttp.Request Episode
request path episodeData body =
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
        (episodeDecoder path episodeData body)


type alias Episode =
    { publishAt : Time.Posix
    , title : String
    , duration : Int
    , number : Int
    , description : String
    , guid : String
    , audio :
        { url : String
        , sizeInBytes : Int
        }
    , showNotesHtml : String
    , path : PagePath Pages.PathKey
    }


episodeDecoder : PagePath Pages.PathKey -> Metadata.EpisodeData -> String -> Decoder Episode
episodeDecoder path episodeData body =
    Decode.map8 (Episode episodeData.publishAt)
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
        (bodyDecoder body)
        (Decode.succeed path)


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
                        |> List.map itemToString
                        |> String.join "\n"
                  )
                , ( "lastBuiltAt"
                  , Pages.builtAt |> Imf.fromPosix Time.utc
                    --"Fri, 3 Apr 2020 15:18:06 +0000"
                  )
                ]
            )


itemToString : Episode -> String
itemToString episode =
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
                  , episode.publishAt |> Imf.fromPosix Time.utc
                  )

                --"Fri, 3 Apr 2020 15:12:18 +0000"
                , ( "link", "https://elm-radio.com/" ++ PagePath.toString episode.path )
                , ( "sizeInBytes", episode.audio.sizeInBytes |> String.fromInt )
                , ( "showNotesHtml", episode.showNotesHtml )
                ]
            )


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
