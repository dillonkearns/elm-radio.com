---
type: episode
number: 31
title: Elm Code Generation
description: We discuss different use cases for code generation in Elm applications, and our favorite code generation tips.
simplecastId: 58152ce7-f1b3-4969-8de7-c1729105fecf
---

- What's the source of truth?
- Teach the Elm compiler about external things like schemas
- Elm graphql
- Types without borders

- Macros in other languages
- C has preprocessor macros
- Lisp has ast macros
- Rescript ppx macros
- Vanilla code generation is easier to inspect, debug, understand because it just gives you plain code like your hand written code
- Gitignore gen code so you know you didn't forget to generate it on the build server

- Watching
- Rerun code gen when the source of truth changes ideally
- Chokidar cli
- Design of everyday things
- Affordances
- Mappings
- Elm tailwind modules
- Chad tech vector

- Salix
- Elm ts interop

## Scaffolding

- Elm review init and new rule new package
- Elm spa init
- Html to Elm.com
- End to end testing your generated code
- Snapshot testing
- Elm-graphql snapshot testing script
- Html to Elm generated test suite
- Elm verify examples
