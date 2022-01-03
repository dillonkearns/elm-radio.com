---
type: episode
number: 47
title: What's Working for Elm
description: We look at what we can learn by understanding what's working well for Elm and the Elm ecosystem.
simplecastId: cc985f8e-f8d6-43ea-b8c0-5499e2c217c5
---

- Woody Zuill on [Turn Up the Good](https://archive.oredev.org/2018/2018/sessions/turn-up-the-good)
- [Mob Programming](https://mobprogramming.org/)

## Where Could We Turn Up the Good?

### Pure FP

- Elm 0.19 removing side effects
- Purity is what makes `elm-review` interesting
- Jeroen's post [Safe dead code removal in a pure functional language](https://jfmengels.net/safe-dead-code-removal/)
- No runtime exceptions

### Useful Error Messages

Useful error messages

- Evan's 2017 Deconstructconf talk [Evan Czaplicki On Storytelling](https://www.deconstructconf.com/2017/evan-czaplicki-on-storytelling)
- Evan's talk [What is Success?](https://www.youtube.com/watch?v=uGlzRt-FYto)

### Having a single language flavor

- [Isomorphic code](https://en.wikipedia.org/wiki/Isomorphic_JavaScript)
- Meta frameworks (`elm-pages`, Lamdera, `elm-spa`)

### Decoupled tools

- The community can iterate quickly and experiment with new changes
- `elm-optimize-level-2` and `elm-format` are great examples
- `elm-optimize-level-2` can make their way upstream and don't break Elm's guarantees or assumptions
- Robin Hansen's blog post series [Successes, and failures, in optimizing Elm’s runtime performance](https://blogg.bekk.no/successes-and-failures-in-optimizing-elms-runtime-performance-c8dc88f4e623)
- [Extensible Web Manifesto](https://github.com/extensibleweb/manifesto)
- Platform should provide building blocks, not solve every specific use case

## Stable Core

- Stable data layer, architecture allows ecosystem to evolve around it with less churn

## Community Members Working on What They're Passionate About

- People passionate about a problem working on it in the ecosystem

## Performance

- Leveraging Elm's unique characteristics for performance (immutability, static language, known types, etc.)
- Elm compiler performance - compiler speed matters

## Content and Conferences

- Elm community content and conferences
- Elm Online meetdown

## The Elm Philosophy

- Evan's [Elm philosophy tweet](https://twitter.com/evancz/status/928359033844539393)
- Philosophy has influenced package design in the ecosystem
- Elm Slack #api-design channel
