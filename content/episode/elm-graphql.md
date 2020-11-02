---
type: episode
number: 16
title: elm-graphql
description: We talk about elm-graphql, how to organize your SelectionSets, and other best practices.
simplecastId: 4f81efc2-b016-465c-899a-ab66f973b9a6
---

- [`dillonkearns/elm-graphql`](https://github.com/dillonkearns/elm-graphql)
- Elm Radio [episode 4 - JSON decoders](https://elm-radio.com/episode/json-decoders)
- Dillon's Elm Conf talk about the principles behind elm-graphql: [Types Without Borders](https://www.youtube.com/watch?v=memIRXFSNkU)
- [Phantom Types](https://medium.com/@ckoster22/advanced-types-in-elm-phantom-types-808044c5946d)
- [`elm-graphql`'s FAQ document](https://github.com/dillonkearns/elm-graphql/blob/master/FAQ.md)
  Article about simple design in Elm
- elm-graphql [Scalar Codecs tutorial](https://incrementalelm.com/scalar-codecs-tutorial/)

## How can elm graphql decoding fail?

- [`SelectionSet.nonNullOrFail`](https://package.elm-lang.org/packages/dillonkearns/elm-graphql/latest/Graphql-SelectionSet#nonNullOrFail)
- [`SelectionSet.mapOrFail`](https://package.elm-lang.org/packages/dillonkearns/elm-graphql/latest/Graphql-SelectionSet#mapOrFail)
- Custom Scalars don't include type information, though there are [some proposals for supporting optional type information](https://github.com/graphql/graphql-spec/issues/635)

## Backend Frameworks for Full-Stack GraphQL Type Safety

- [Juniper](https://github.com/graphql-rust/juniper) for Rust
- [Hasura](https://hasura.io/) (database-schema based API)
- [Postgraphile](https://www.graphile.org/postgraphile/) (database-schema based API)

- [Discourse thread on differences between all the Elm graphql libraries](https://discourse.elm-lang.org/t/introducing-graphqelm-a-tool-for-type-safe-graphql-queries/472/5)
- [`harmboschloo/graphql-to-elm`](https://github.com/harmboschloo/graphql-to-elm) - library for generating Elm functions to make queries from GraphQL strings
