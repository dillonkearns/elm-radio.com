---
type: episode
number: 62
title: elm-test v2 with Martin Janiczek
description: Martin Janiczek joins us to talk about fuzz testing, why it matters, and how the upcoming elm-test v2 changes the way you write fuzzers in Elm.
simplecastId: TODO
---

- [`elm-test` episode](https://elm-radio.com/episode/elm-test/)
- Fuzzing is also known as Property-Based Testing
- [Parameterized tests](https://www.baeldung.com/parameterized-tests-junit-5)
- [Martin's pure Elm text editor](https://github.com/Janiczek/elm-editor) includes [some fuzz tests](https://github.com/Janiczek/elm-editor/blob/30470fe2fdc2dbc1dedec1b4db2fc8cd6bd3664e/tests/Tests/Common.elm)
- Martin's [pull request for the elm-test v2 changes](https://github.com/elm-explorations/test/pull/151)
- [Integrated shrinking vs the value-based (AKA type-based) approach](https://hypothesis.works/articles/types-and-properties/)
- `Fuzz.andThen` and `Fuzz.filter` (existed in 0.18 but were removed because they didn't shrink well)
- [elm-test v2 upgrade guide and change notes](https://gist.github.com/Janiczek/2e5cf91694851866fda9089d649baad9)
- Passing in random generators in elm-test v2 doesn't do shrinking so best to avoid that escape hatch and instead implement an equivalent fuzzer
- Scott Wlaschin's post [Choosing properties for property-based testing](https://fsharpforfunandprofit.com/posts/property-based-testing-2/)
- [Discourse post on call for testing help and how to install the beta release](https://discourse.elm-lang.org/t/call-for-testing-of-elm-explorations-test-2-0-0/8458)
- Martin's [video series on designing the new fuzz testing API](https://www.youtube.com/watch?v=Pym32n6AfSs&list=PLymbvEbZ-wpXqyoqFpmUYiNcy2E7r3vzH)
- `#testing` channel on the Elm Slack
- [Hypothesis library](https://github.com/HypothesisWorks/hypothesis)
- [Hypothesis project's blog](https://hypothesis.works/articles/)
- A paper about the Hypothesis reduction approach: [Test-Case Reduction via Test-Case Generation: Insights From the Hypothesis Reducer](https://drmaciver.github.io/papers/reduction-via-generation-preview.pdf)
