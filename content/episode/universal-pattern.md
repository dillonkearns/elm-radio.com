---
type: episode
number: 32
title: Elm's Universal Pattern
description: Guest Joël Quenneville shares his wisdom on transforming and mapping in Elm, and how it applies across many Elm data types.
simplecastId: 01c69c6f-6327-4cac-9217-348fa97b3813
---

- Joël Quenneville ([Twitter](https://twitter.com/joelquen))
- Joël's blog post [Elm's Universal Pattern](https://thoughtbot.com/blog/elms-universal-pattern)
- `map2`
- `Maybe.map2`

## Metaphors

Some common metaphors for Elm's Universal Pattern (Applicative Pattern).

- Mapping
- Combining
- Lifting
- Wrapping and unwrapping boxes

- Blog post on [Two ways of looking at map functions](https://thoughtbot.com/blog/two-ways-of-looking-at-map-functions)

## Examples

- Random generators
- Apply mapping functions to vanilla value functions to keep things clean

## Tips

- Separate branching code from doing code (discussed in-depth in Joël's blog post [Problem Solving with Maybe](https://thoughtbot.com/blog/problem-solving-with-maybe))
- Stay at one level of abstraction

- Json decoders as combining functions
- Scott Wlaschin [Railway Oriented Programming](https://fsharpforfunandprofit.com/rop/)
- Dillon's blog post [Combinators - Inverting Top-Down Transforms](https://incrementalelm.com/tips/combinators/)
- The JSON structure and Elm type don't have to mirror each other - start with your ideal type and work backwards

- Applicative pattern
- Applicative needs 1) way to construct, 2) `map2` or `andMap`
- [`Json.Decode.Pipeline.required`](https://package.elm-lang.org/packages/NoRedInk/elm-json-decode-pipeline/latest/Json-Decode-Pipeline#required) function

## Record constructors

- Practice writing it with an anonymous function to convince yourself it's equivalent
- Record constructors are just a plain old elm function
- `map2` doesn't take a type, it takes a function -
- [`NoRedInk/elm-json-decode-pipeline`](https://package.elm-lang.org/packages/NoRedInk/elm-json-decode-pipeline/latest/) is a useful reference for implementing this kind of api on your own
- [Applicative Laws in Haskell](https://en.wikibooks.org/wiki/Haskell/Applicative_functors#Applicative_functor_laws)
- Monomorphic vs polymorphic
- Parser Combinators
- [`elm/parser` episode](https://elm-radio.com/episode/elm-parser)
- [Joël's blog posts on the ThoughtBot blog](https://elm-radio.com/episode/elm-parser)
- Joël's [Random generators talk](https://www.youtube.com/watch?v=YxGWQdFo2Yc)
- Joël's [Maybe talk](https://www.youtube.com/watch?v=43eM4kNbb6c)

Some more blog posts by Joël that related to Elm's Universal Pattern:

- [Running out of maps](https://thoughtbot.com/blog/running-out-of-maps)
- [Pipeline Decoders in Elm](https://thoughtbot.com/blog/pipeline-decoders-in-elm)

Joël's journey to building a parser combinator:

- Nested cases - https://ellie-app.com/b9nGmZVp9Vca1
- Extracted Result functions - https://ellie-app.com/b9qtqTf8zYda1
- Introducing a Parser alias and map2 - https://ellie-app.com/b9MwZ3y4t8ra1
- Re-implementing with elm/parser - https://ellie-app.com/b9NZhkTGdfya1
- [Getting Unstuck with Elm JSON Decoders](https://thoughtbot.com/blog/getting-unstuck-with-elm-json-decoders) - because mapping is universal, you can solve equivalent problems with the same pattern (described in this post)
