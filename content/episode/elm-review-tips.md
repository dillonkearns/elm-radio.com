---
type: episode
number: 21
title: elm-review Tips
description: We revisit elm-review with some tips, useful workflows, and helpful packages that have come out since our intro to elm-review episode.
simplecastId: 15d80274-0209-4b48-a927-870b7b5c9911
---

- The [`npx` command](https://nodejs.dev/learn/the-npx-nodejs-package-runner) runs NPM binaries from your shell

Some tricks to easily [try `elm-review`](https://github.com/jfmengels/elm-review#try-it-out) with no setup:

```shell
npx elm-review --template jfmengels/elm-review-unused/example
```

Init with a given template:

```shell
npx elm-review init --template jfmengels/elm-review-unused/example
```

## Incremental adoption

- Don't enable lots with errors, better to have few with no errors
- Enable in CI
- [`ignoreErrorsForFiles`](https://package.elm-lang.org/packages/jfmengels/elm-review/latest/Review-Rule#ignoreErrorsForFiles)
- [`ignoreErrorsForDirectories`](https://package.elm-lang.org/packages/jfmengels/elm-review/latest/Review-Rule#ignoreErrorsForDirectories)
- Try the `--fix`, `--fix-all`, and `--watch` flags (see how to [run elm-review](https://github.com/jfmengels/node-elm-review#run-a-review))

## Useful packages and workflow

- Review rule for [Documentation.ReadmeLinksPointToCurrentVersion](https://package.elm-lang.org/packages/jfmengels/elm-review-documentation/1.0.1/Documentation-ReadmeLinksPointToCurrentVersion)
- [`elm-verify-examples`](https://github.com/stoeffel/elm-verify-examples)
- [Safe unsafe operations in Elm](https://jfmengels.net/safe-unsafe-operations-in-elm/) blog post
- [`elm-spa` Elm Radio episode](https://elm-radio.com/episode/elm-spa)
- [`jfmengels/elm-review-debug`](https://package.elm-lang.org/packages/jfmengels/elm-review-debug/latest/)
- [`jfmengels/elm-review-common`](https://package.elm-lang.org/packages/jfmengels/elm-review-common/latest)

- [`sparksp/elm-review-ports`](https://package.elm-lang.org/packages/sparksp/elm-review-ports/latest/)
- [`sparksp/elm-review-imports`](https://package.elm-lang.org/packages/sparksp/elm-review-imports/latest/)
- [Getting started with elm-review](https://elm-radio.com/episode/getting-started-with-elm-review) episode
- [Incremental Steps](https://elm-radio.com/episode/incremental-steps) episode
