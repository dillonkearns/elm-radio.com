---
type: episode
number: 29
title: Writing an elm-review Rule
description: We walk through how to write an elm-review rule from scratch. Also, how to test your rules, and how to write an automated fix.
simplecastId: fb4e1892-434a-4736-a30b-11a0a39aae63
---

- [`dillonkearns/elm-review-html-to-elm`](https://package.elm-lang.org/packages/dillonkearns/elm-review-html-to-elm/latest/) (elm-review version of [html-to-elm.com](https://html-to-elm.com/))

- [Rule naming guidelines docs](https://package.elm-lang.org/packages/jfmengels/elm-review/latest/Review-Rule#a-good-rule-name)
- Elm review cli new rule command

- [stil4m/elm-syntax](https://package.elm-lang.org/packages/stil4m/elm-syntax/latest/)
- [`Elm.Syntax.Range`](https://package.elm-lang.org/packages/stil4m/elm-syntax/latest/Elm-Syntax-Range#Range)
- [`elm-review` `ignoreErrorsForFiles`](https://package.elm-lang.org/packages/jfmengels/elm-review/latest/Review-Rule#ignoreErrorsForFiles)
- Review context
- [`withFinalModuleEvaluation`](https://package.elm-lang.org/packages/jfmengels/elm-review/latest/Review-Rule#withFinalModuleEvaluation)
- `elm-review`'s context is like `Model`, elm-syntax `Node` is like a `Msg`, [Review `Error`s](https://package.elm-lang.org/packages/jfmengels/elm-review/latest/Review-Rule#Error) are `Cmd`s, visitors are like `update`
- `elm-review`'s new [configuration errors API](https://package.elm-lang.org/packages/jfmengels/elm-review/latest/Review-Rule#configurationError)
- Import aliases feature: [`ModuleNameLookupTable`](https://package.elm-lang.org/packages/jfmengels/elm-review/latest/Review-ModuleNameLookupTable)
- [Parse, don't validate episode](https://elm-radio.com/episode/parse-dont-validate)

- `elm-review` [Fixes API](https://package.elm-lang.org/packages/jfmengels/elm-review/latest/Review-Fix)
- Jeroen's [Safe Unsafe Operations](https://jfmengels.net/safe-unsafe-operations-in-elm/) blog post

## Getting started

Some repos to look at for inspiration

- [github.com/jfmengels/elm-review-unused](https://github.com/jfmengels/elm-review-unused)
- [github.com/jfmengels/elm-review-common ](https://github.com/jfmengels/elm-review-common)
- [github.com/jfmengels/elm-review-debug ](https://github.com/jfmengels/elm-review-common)
- [github.com/jfmengels/elm-review-simplify ](https://github.com/jfmengels/elm-review-common)

The [`elm-review` package docs](https://package.elm-lang.org/packages/jfmengels/elm-review/latest/) are very through and worth reading
