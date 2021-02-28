---
type: episode
number: 25
title: elm-ts-interop
description: elm-ts-interop is a tool that keeps types in sync between your Elm ports and JavaScript (or TypeScript) wiring code. We talk about the new design and compare it to the original.
simplecastId: af75e6d9-b465-4e26-8200-3455cabf65fd
---

- [`elm-ts-interop`](https://elm-ts-interop.com/)
- Now-deprecated original library - [`elm-typescript-interop`](https://github.com/dillonkearns/elm-typescript-interop)
- [The Importance of Ports](https://www.youtube.com/watch?v=P3pL85n9_5s) - Elm Conf talk by Murphy Randle
- Evan's [Vision for Data Interchange document](https://gist.github.com/evancz/1c5f2cf34939336ecb79b97bb89d9da6) recommends against implicit serialization. The deprecated `elm-typescript-interop` relied on Elm's automatic JSON serialization flags/ports. `elm-ts-interop` passes `Json.Decode.Value`'s [which is what the guide recommends](https://guide.elm-lang.org/interop/flags.html).
- Blog post about [TypeScript's Blind Spots](http://incrementalelm.com/tips/typescript-blind-spots)
- TypeScript [discriminating unions](https://www.typescriptlang.org/docs/handbook/unions-and-intersections.html#discriminating-unions) are analagous to Elm custom types
- [Types Without Borders](https://www.youtube.com/watch?v=memIRXFSNkU) Elm Conf talk
- [`elm-ts-json` Elm pacakge](https://package.elm-lang.org/packages/dillonkearns/elm-ts-json/latest)
- [Elm ts interop npm package](http://npmjs.com/package/elm-ts-interop)

## What's the source of truth?

- [Nexus](https://nexusjs.org/) - code-first GraphQL server
- [`graphql-js`](https://github.com/graphql/graphql-js) - schema-first GraphQL
- [Hasura](https://hasura.io/) and [PostGraphile](https://www.graphile.org/) - Postgres schema is the source of truth
- [Elm Codecs episode](/episode/codecs/)
- [`elm-ts-json` Encode docs](https://package.elm-lang.org/packages/dillonkearns/elm-ts-json/latest/TsJson-Encode)

## Getting Started

- Get your discount code, and learn more about the Pro version, including the scaffolding tool and Pro CLI at [elm-ts-interop.com](https://elm-ts-interop.com).

Two articles about the redesign of `elm-ts-interop` (originally published in Bekk's Functional Christmas posts)

- [Combinators - Inverting Top-Down Transforms](https://incrementalelm.com/tips/combinators)
- [Types Without Borders Isn't Enough](https://incrementalelm.com/tips/types-without-borders-isnt-enough/)
