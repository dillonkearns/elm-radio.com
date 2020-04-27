---
type: episode
number: 4
title: JSON Decoders
description: We discuss the basics of JSON Decoders, benefits compared to JSON in JavaScript, best practices, and how to get started learning.
publishAt: 2020-04-27T11:00:00+0000
simplecastId: ad4a71cc-9edd-4b56-b9a0-14d012796931
---

## Basics

* [`elm/json` package docs](https://package.elm-lang.org/packages/elm/json/latest/)
* [Elm Guide section on JSON Decoders](https://guide.elm-lang.org/effects/json.html)
* Validates that data has the expected shape. Similar to the pattern we discussed in [episode 002 Intro to Opaque Types](/episode/intro-to-opaque-types).

## Ports and Flags

Here's an [Ellie example](https://package.elm-lang.org/packages/elm/json/latest/) that shows the error when you have an implicit type that your flags decode to and it's incorrect.

Sorry Dillon... Jeroen won the trivia challenge this time 😉 It turns out that ports will throw exceptions when they are given a bad value from JavaScript, but it doesn't bring down your Elm app. Elm continues to run with an unhandled exception. Here's an [ Ellie example](https://package.elm-lang.org/packages/elm/json/latest/).

Flags and ports will never throw a runtime exception in your Elm app if you always use `Json.Decode.Value`s and `Json.Encode.Value`s for them and handle unexpected cases. Flags and ports are the one place that Elm lets you make unsafe assumptions about JSON data.

## Benefits of Elm's Approach to JSON

* Bad data won't end up deep in your application logic where it's hard to debug (and discover in the first place)
* Decouples serialization format from your Elm data types
* You can do data transformations locally as you build up your decoder, rather than passing your giant data structure through a single transform function

## Decoding Into Ideal Types

* Richard Feldman's [`elm-iso8601 package`](https://package.elm-lang.org/packages/rtfeldman/elm-iso8601-date-strings/latest/)
* [`elm/time package`](https://package.elm-lang.org/packages/elm/time/latest/)
* [Programming by intention](https://package.elm-lang.org/packages/elm/json/latest/) 
* [`Json.Decode.succeed`](https://package.elm-lang.org/packages/elm/json/latest/Json-Decode#succeed) is helpful for stubbing out data
* Dillon's [Incremental Type Driven Design talk](https://www.youtube.com/watch?v=mrwn2HuWUiA) at elm Europe
* [`Json.Decode.fail`](https://package.elm-lang.org/packages/elm/json/latest/Json-Decode#fail) lets you validate data and fail your whole decoder if there’s a problem
* [Parse, don’t validate](https://lexi-lambda.github.io/blog/2019/11/05/parse-don-t-validate/) blog post by Alexis King
* Dillon's [`elm-cli-options-parser`](https://github.com/dillonkearns/elm-cli-options-parser) package
* [`Json.Decode.maybe` docs](https://package.elm-lang.org/packages/elm/json/latest/Json-Decode#maybe)

## Learning resource

* Brian Hicks' book [The JSON Survival Kit](https://www.brianthicks.com/json-survival-kit/)

### Joël Quenneville’s Blog Posts About JSON Decoders

* [Getting Unstuck with Elm JSON Decoders](https://thoughtbot.com/blog/getting-unstuck-with-elm-json-decoders)
* [5 Common JSON Decoders](https://thoughtbot.com/blog/5-common-json-decoders)
* [Elm's Universal Pattern](https://thoughtbot.com/blog/elms-universal-pattern)


## Guaranteeing that json is valid before runtime

* [`elm-graphql` package](https://github.com/dillonkearns/elm-graphql)
* The [basics of GraphQL](graphql.org/learn)
* Dillon's [Types Without Borders](https://www.youtube.com/watch?v=memIRXFSNkU) Elm Conf talk
* [Elm Radio 001 Getting Started with `elm-pages`](/episode/getting-started-with-elm-pages)
* [`elm-pages` `StaticHttp` API docs](https://package.elm-lang.org/packages/dillonkearns/elm-pages/latest/Pages-StaticHttp)
* Kris Jenkins' [elm-export](https://github.com/krisajenkins/elm-export) tool for Haskell types to Elm.
* Mario Rogic's [Evergreen Elm](https://www.youtube.com/watch?v=4T6nZffnfzg) elm Europe talk

## Autogenerating json decoders

* [json-to-elm](https://noredink.github.io/json-to-elm/) tool - generates Elm decoders from raw JSON values
* [`intellij-elm` JSON decoder generator](https://github.com/klazuka/intellij-elm/blob/master/docs/features/generate-function-json.md)

## Organizing your decoders

* Evan Czaplicki's elm Europe keynote [The life of a file](https://www.youtube.com/watch?v=XpDsk374LDE)
* [Evan's experience report on implicit decoding in Haskell](https://gist.github.com/evancz/1c5f2cf34939336ecb79b97bb89d9da6#gistcomment-2606737)

## Getting Started

* Understand [`Json.Decode.map`](https://package.elm-lang.org/packages/elm/json/latest/Json-Decode#map)
* Understand record type aliases - the function that comes from defining `type alias Album = { ... }`


[Submit your question](https://elm-radio.com/question) to Elm Radio!