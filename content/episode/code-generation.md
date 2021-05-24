---
type: episode
number: 31
title: Elm Code Generation
description: We discuss different use cases for code generation in Elm applications, and our favorite code generation tips.
simplecastId: 58152ce7-f1b3-4969-8de7-c1729105fecf
---

- What's the source of truth?
- Teach the Elm compiler about external things like schemas
- [`elm-graphql`](https://github.com/dillonkearns/elm-graphql)
- [`dillonkearns/elm-graphql`](https://package.elm-lang.org/packages/dillonkearns/elm-graphql/latest/)
- [Types Without Borders](https://www.youtube.com/watch?v=memIRXFSNkU)

- Macros in other languages
- [C macros compared to Lisp macros](https://wiki.c2.com/?LispMacro)
- [ReScript ppx macros](https://rescript-lang.org/docs/manual/latest/project-structure#ppx--other-meta-tools)
- Vanilla code generation can be inspected and debugged like plain handwritten code
- Gitignore gen code so you know you didn't forget to generate it on the build server

## Watchers for rerunning codegen

- Rerun code gen when the source of truth changes ideally
- [Chokidar CLI](https://www.npmjs.com/package/chokidar-cli)
- [The Design of Everyday Things](https://en.wikipedia.org/wiki/The_Design_of_Everyday_Things) by Donald Norman
- Affordances
- Mappings
- [`elm-tailwind-modules`](https://github.com/matheus23/elm-tailwind-modules)
- [`Chadtech/elm-vector`](https://package.elm-lang.org/packages/Chadtech/elm-vector/latest/)

- [`the-sett/salix`](https://package.elm-lang.org/packages/the-sett/salix/latest/)
- [`elm-ts-interop`](http://elm-ts-interop.com/)

## Scaffolding

- `elm-review init`, `new-rule`, and `new-package`
- `elm-spa new`
- [html-to-elm.com](https://html-to-elm.com)
- End to end testing your generated code
- Snapshot testing
- [`elm-graphql`'s snapshot testing script](https://github.com/dillonkearns/elm-graphql/blob/02c59a90ba497d9e2e88aeb181bc941239b23214/bin/approve)
- [html-to-elm.com generated test suite](https://github.com/dillonkearns/elm-review-html-to-elm/blob/6ab84679ae213d5b73caf3ce82ed3ee93d31dc6c/ete-tests/mocha-test.js)
- [`elm-verify-examples`](https://github.com/stoeffel/elm-verify-examples)
