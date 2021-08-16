---
type: episode
number: 37
title: Performance in Elm
description: We talk about performance tuning Elm applications.
simplecastId: f260a2c1-76a9-4e8d-b8e9-680424e9f668
---

- [`elm-review-performance`](https://package.elm-lang.org/packages/jfmengels/elm-review-performance/latest/)
- Tail call optimizations
- Jeroen's blog post on [Tail-call optimization in Elm](https://jfmengels.net/tail-call-optimization/)
- Evan Czaplicki's chapter on [Tail-Call Optimization](https://functional-programming-in-elm.netlify.app/recursion/tail-call-elimination.html) and how to write optimized code
- [Lighthouse Elm Radio episode](https://elm-radio.com/episode/lighthouse)
- Ju Liu's [Performant Elm](https://juliu.is/performant-elm/) blog post series
- Avoid memoized state when possible to avoid stale data
- [`Html.Lazy`](https://package.elm-lang.org/packages/elm/html/latest/Html-Lazy)
- Elm's html lazy only works when the function and args have the same reference as before. `List.map` will return a list with a new reference, for example.
- Elm has function-level dead code elimination
- Referencing a record pulls the whole record in no matter how many fields are used directly
- [`bcp-47-language-tag`](https://package.elm-lang.org/packages/dillonkearns/elm-bcp47-language-tag/latest/) package
- Elm list extra gets split by function, unlike lodash which needs to be split
- [Elm Core Dict package](https://package.elm-lang.org/packages/elm/core/latest/Dict) has [O(logn)](https://stackoverflow.com/a/2307314) complexity for operations like insert
- JavaScript Objects aren't optimized for removing/adding properties
- ["What's Up With Monomorphism"](https://mrale.ph/blog/2015/01/11/whats-up-with-monomorphism.html)
- [`elm-optimize-level-2`](https://discourse.elm-lang.org/t/announcing-elm-optimize-level-2/6192)
- [`elm-explorations/benchmark`](https://package.elm-lang.org/packages/elm-explorations/benchmark/latest/)
- Jeroen's list-extra PRs (with reference to the benchmark for it) for functions [`gatherWith`](https://github.com/elm-community/list-extra/pull/147) [`isInfixOf`](https://github.com/elm-community/list-extra/pull/148)
- [webpagetest.org](https://www.webpagetest.org/) (or [web.dev performance testing](https://web.dev/measure/))
- [Netlify Lighthouse plugin](https://github.com/netlify-labs/netlify-plugin-lighthouse)
- [RSLint](https://github.com/netlify-labs/netlify-plugin-lighthouse) - fast version of ESLint, but doesn't have custom rules
- [Instructions to minify Elm code](https://discourse.elm-lang.org/t/what-i-ve-learned-about-minifying-elm-code/7632)
- Jake and Surma talk about optimizing sites - [Setting up a static render in 30 minutes](https://www.youtube.com/watch?v=TsTt7Tja30Q)
- Jake Archibald's talk explaining JavaScript's event loop and requestAnimationFrame - [In The Loop](https://www.youtube.com/watch?v=cCOL7MC4Pl0)
