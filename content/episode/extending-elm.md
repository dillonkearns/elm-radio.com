---
type: episode
number: 7
title: Extending Elm
description: We discuss what Elm is intended for, techniques for going beyond that, and how to make tools nice to use when you do.
simplecastId: d8db1ad8-9f8e-444f-a863-9ab2e61b7a80
---

- [Platform.worker](https://package.elm-lang.org/packages/elm/core/latest/Platform#worker)

## What can you do with Elm?

- Html
- Http
- Ports
- Web Components

## Different techniques for extending elm

- [elm-pages StaticHttp API](https://package.elm-lang.org/packages/dillonkearns/elm-pages/latest/Pages-StaticHttp)
- [Elm radio episode 1 on elm pages](https://elm-radio.com/episode/getting-started-with-elm-pages)
- [`elm-graphql`](https://github.com/dillonkearns/elm-graphql)
- Codegen
- Macros
- [Elixir exunit](https://hexdocs.pm/ex_unit/ExUnit.Assertions.html#content)
- Wrapper elm apps
- Can emulate effect managers
- Platform.worker
- Introspection
- [elm-typescript-interop](https://github.com/dillonkearns/elm-typescript-interop)

- Ports and flags
- Web Components
- Code transformation
- Elm asset loader webpack
- Hacking JS to get FFI
- Depending on internal details could end up with broken code

[elm-hot and elm-hot-webpack-loader](https://github.com/klazuka/elm-hot-webpack-loader)

## Pitfalls and considerations

Codegen

- Have a single clear source of truth for codegen
- Prevent bad states with airtight abstractions, rather than having lots of caveats
- Make sure public APIs for generated code look nice
- Use doc comments

Macros

- Elm code that doesn’t look like elm code
- Tooling doesn’t work then - see Babel ecosystem
- Violates Open close principle - you’re modifying the language, not extending it

Provide a platform with extensions in mind when you build tools so you don’t require users to hack

When you build a tool, think about the mental model for uses, let that guide you. Avoid leaky abstractions

Be opinionated about the core things, and unopionated about what’s not essential to the tool

- `[elm-spa](https://github.com/ryannhg/elm-spa)`
