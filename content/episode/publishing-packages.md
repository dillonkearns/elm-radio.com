---
type: episode
number: 5
title: How (And When) to Publish a Package
description: We cover the mechanics of publishing your first Elm package. Best practices for making a great package, and how to learn the API design skills to build great tools.
simplecastId: 7b3cd642-0aca-48b3-9343-9519241a3682
---

## What is an Elm Package?

* [Elm package repository](http://package.elm-lang.org/)
* Elm packages enforce SemVer for the public package API
* The [SemVer (Semantic Versioning) Spec](https://semver.org/)
* *Interesting note*: the SemVer spec says breaking changes only refers to the public API. But a core contributor clarifies that breaking changes can come from changes to the public contract that you intend users to depend on. See [this GitHub thread](https://github.com/semver/semver/issues/311#issuecomment-224430886).
* [`list-extra` package](https://package.elm-lang.org/packages/elm-community/list-extra/latest/)
* [`dict-extra` package](https://package.elm-lang.org/packages/elm-community/dict-extra/latest/)
* Minimize dependencies in your package to make it easier for users to manage their dependencies
* "Vendoring" elm packages (using a local copy instead of doing `elm install author/package-name`) can be useful in some cases to remove a dependency from your package

## Should you publish a package?
* The Elm package ecosystem has a high signal to noise ratio
* Elm packages always start at version 1.0.0
* SemVer has different semantics before 1.0.0 (patch releases can be breaking before 1) - see [SemVer spec item 4](https://semver.org/#spec-item-4)


> Major version zero (0.y.z) is for initial development. Anything MAY change at any time. The public API SHOULD NOT be considered stable.

* Elm package philosophy is to do an alpha phase before publishing package

### Keep yourself honest about solving meaningful problems
* Start by asking "What problem are you solving? Who are you solving it for?"
* Scratch your own itch
* [`elm-graphql`](https://github.com/dillonkearns/elm-graphql)
* [`servant-elm`](https://hackage.haskell.org/package/servant-elm) (for Haskell servant)
* Keep yourself honest about solving problems by starting with an `examples/` folder

* [Early `elm-graphql` commits](https://github.com/dillonkearns/elm-graphql/commit/23f4c7f95a620c35d6d5a16f277ff8cd83acca3c) started with examples before anything else
* Write meaningful test cases with [`elm-test`](https://github.com/elm-explorations/test)
* [`elm-verify-examples`](https://github.com/stoeffel/elm-verify-examples)
* Have a clear vision
* Ask people for feedback
* Let ease of explanation guide you to refine core concepts

## Make it easy for people to understand your package goals and philosophy
* Include code examples in readme and docs to make it easier for people to get started
* [`elm-review` live stream video](https://www.youtube.com/watch?v=8WAN6Slslgo)
* Use meaningful examples solving concrete problems (images/screenshots are good, too)
* Richard Feldman's [**Exploring elm-spa-example**](https://www.youtube.com/watch?v=RN2_NchjrJQ) talk
* Luke's [`elm-http-builder`](https://package.elm-lang.org/packages/lukewestby/elm-http-builder/latest/) package
* `elm-spa-example`'s [custom http request builder module](https://github.com/rtfeldman/elm-spa-example/blob/master/src/Api/Endpoint.elm)
* Instead of writing a package, in some cases it could make sense to publish a blog post to share a pattern

## Porting libraries vs. Coming Up With an Idiomatic Solution for Elm
* Instead of moment js ported to Elm, have an API built for a typed context
* Ryan's [`date-format` package](https://package.elm-lang.org/packages/ryannhg/date-format/latest/)

## How to design an Elm package API
* Define your constraints/guarantees, make impossible states impossible
* Charlie Koster's [**Advanced Types in Elm**](https://medium.com/@ckoster22/advanced-types-in-elm-opaque-types-ec5ec3b84ed2) blog post series
* Avoid exposing internals of your data
* Elm Radio episode [002: Intro to Opaque Types](https://elm-radio.com/episode/intro-to-opaque-types)

## Pay attention to how other packages solve problems
* Richard Feldman's talk [The Design Evolution of elm-css and elm-test](https://www.youtube.com/watch?v=n5faeSW71ko)
* Brian Hicks' talk [Let's publish nice packages](https://www.youtube.com/watch?v=yVn7FOQuwDM)
* Look at prior art, including in other ecosystems
* Look at github issues and blog posts from projects in other ecosystems

## Pick your constraints instead of trying to solve every problem
* Helps you choose between tradeoffs
* Having clear project goals explicitly in your Readme makes it easier to discuss tradeoffs with users and set expectations
* [Idiomatic elm package guide](https://github.com/dillonkearns/idiomatic-elm-package-guide) has lots of info on basic mechanics and best practices for publishing Elm packages

## The mechanics of publishing an elm package
* `elm make --docs docs.json` will tell you if you're missing docs or if there are documentation validation errors
* [`elm-doc-preview`](https://github.com/dmy/elm-doc-preview)
* Can use [elm-doc-preview site](https://elm-doc-preview.netlify.com/) to share documentation of branches, or packages that haven't been published yet
* Set up a CI
* Dillon's [CI script for `dillonkearns/elm-markdown` package](https://github.com/dillonkearns/elm-markdown/blob/master/.github/workflows/ci.yml)
* Dillon's [`elm-publish-action` GitHub Action](https://github.com/dillonkearns/elm-publish-action) will publish package versions when you increment the version in your `elm.json` - nice because it runs CI checks before finalizing a new package release
* `elm publish` will walk you through the steps you need before publishing the first version of your Elm package
* `#packages` channel on [the Elm slack](https://elmlang.herokuapp.com/) shows a feed of packages as they're published
* `#api-design` channel on the Elm slack is a good place to ask for feedback on your API design and package idea

## Continue the Conversation
Share your package ideas with us [@elmradiopodcast](https://twitter.com/elmradiopodcast) on Twitter!
