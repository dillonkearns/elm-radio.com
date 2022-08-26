---
type: episode
number: 64
title: Projects We Wish We Had Time For
description: We discuss the power of the Elm when paired with developer tools, and we go through our notes to look at Elm tools we wish we had the time to build.
simplecastId: 8595bb14-a2c7-4c98-83d1-8912a5649cc7
---

Sponsor: CareRev

CareRev is looking for Senior Frontend Elm engineers ([job listing](https://boards.greenhouse.io/carerev/jobs/5053217003)).

- [`elm-review-simplify`](https://package.elm-lang.org/packages/jfmengels/elm-review-simplify/latest/)
- Elm Radio [Root Cause of False Positives episode](https://elm-radio.com/episode/false-positives/)
- [Dillon's pairing session using snapshot testing prototype with Corey Haines](https://www.youtube.com/watch?v=rOJ4AfJ0ZdM)
- [`elm-snapshot-test` prototype repo](https://github.com/dillonkearns/elm-snapshot-test)
- [Approval testing](https://approvaltests.com/)
- [`elm-coverage`](https://github.com/zwilias/elm-coverage)
- [`elm-instrument`](https://github.com/zwilias/elm-instrument)
- [Llewellyn Falco Gilded Rose kata video](https://www.youtube.com/watch?v=wp6oSVDdbXQ)
- Idea: intellij integration for `elm-coverage`
- Idea: code actions for safe refactorings
- Idea: elm-review integration in intellij (link to unfinished branch)
- Idea: [`sparksp/elm-review-imports`](https://package.elm-lang.org/packages/sparksp/elm-review-imports/latest/) either new feature, or separate project to give suggestions to make all inconsistent imports in a project consistent
- Idea: `elm-review` code actions
- Idea: `elm-review` collection mechanism to gather data from an AST
- [Pairwise testing (or all pairs)](https://github.com/approvals/ApprovalTests.Java/blob/5b5ac443440ae625e47dda7e3b7a198330865d47/approvaltests/docs/Features.md#combinationapprovalsverifybestcoveringpairs)
- Idea: pairwise permutation API that minimizes the number of permutations to go through to get complete coverage
- Idea: [mutation testing](https://en.wikipedia.org/wiki/Mutation_testing) tool for Elm (is Phillip's tool relevant here?)
- Idea: generated API for `elm-graphql` but with factory-style API for mocking out data that is compliant to the graph schema, for use with things like `elm-program-test`
- Idea: `Browser.application` wrapper that provides some common initial flags like start time, initial window dimensions etc
- Idea: HTTP Error type to get bad status payload that can be shared between libraries to reuse the same type (similar to [the `HttpError` type defined in `elm-graphql`](https://package.elm-lang.org/packages/dillonkearns/elm-graphql/latest/Graphql-Http#HttpError))
- Aaron's community-standard [`elm-color` package](https://package.elm-lang.org/packages/avh4/elm-color/latest/)
- Idea: tool to automatically vendor or un-vendor Elm packages
- Idea: `elm-format` in Elm
- Idea: `elm diff`, but it gives you more detailed information about code changes even if they don't change the API
- Idea: Phantom Builder analyzer that generates a state diagram from Elm code
- Idea: suggest types based on what's possible in your current editor context
- Idea: `elm-review` type inference and value inference in `elm-review`
- [elm-http-fusion](https://fusion.lamdera.app/)
- Idea: use a collection of HTTP requests to an endpoint in `elm-http-fusion` to gather better type incormation about an API
- Idea: make tools like `elm-http-fusion` embeddable in the elm-pages dev server so you can interactively fix decoder errors, etc.
- Idea: elm-pages dev server code actions from the UI, like scaffolding new routes
- [elm-codegen](https://github.com/mdgriffith/elm-codegen)
- Idea: use `elm-codegen` for elm-pages scaffolding for user-customizable templates
- Official Elm blog post [The Syntax Cliff](https://elm-lang.org/news/the-syntax-cliff)
- Idea: show ANSI color code error messages embedded in blog posts
- Haley language (for teaching) felina herman lamda days talk
- [Elm Guide translated into French](https://github.com/elm-france/guide.elm-lang.org)
- Idea: translatable error messages and language keywords for Elm
- Idea: `elm-css` tool to make inline styles into static CSS files and replace the styles with a reference to the generated class. Goal: reduce bundle size and performance overhead
- Idea: codemod tool to post-process Elm code using `elm-review` fixes in a hidden temp directory
- Idea: Elm step debugger
- Idea: `elm/parser` debugger to see the state machine of what has been consumed
- Idea: Elm debugger improvements like filtering Msg types, customizable inspecting for certain types
- Idea: inspectable `Cmd`s in the debugger, or similar idea for debugging `elm-pages` DataSources to see why a failure happened and what the breadcrumbs are
- Idea: [React `ink`](https://github.com/vadimdemedes/ink), but for Elm
- [`awesome-elm-sponsorship` repo](https://github.com/jfmengels/awesome-elm-sponsorship)
