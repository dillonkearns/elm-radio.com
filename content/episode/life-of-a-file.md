---
type: episode
number: 14
title: The Life of a File
description: We revisit Evan's classic talk and dive into the process for how and when to split out Elm code into modules.
simplecastId: e783103c-eca7-4041-ab21-b966ccab1521
---

- Evan Czaplicki's talk [The Life of a File](https://www.youtube.com/watch?v=XpDsk374LDE).
- Richard Feldman's [Frontend Masters Elm courses](https://frontendmasters.com/courses/advanced-elm/)
- Explore many different data modeling options
- [Make Impossible States Impossible Elm Radio episode](https://elm-radio.com/episode/impossible-states)

- Wait until you feel the pain vs create abstractions before you need them
- Does the code quality metric of line count apply in Elm since there's no spooky action at a distance
- Aim for loose coupling, high cohesion
- Localized reasoning

Core mechanics of Elm modules

1. (Organize) Grouping functions values types
2. (Hide) You can hide some of those things. Allows encapsulation, shielding from breaking changes, avoiding coupling.

- Create modules around domain concepts
- Use [ubiquitous language](https://thedomaindrivendesign.io/developing-the-ubiquitous-language/)

## Giant update functions

- You can think of the update function as a delegator - get things to the right place rather than doing the work itself

- [`elm-review`](https://package.elm-lang.org/packages/jfmengels/elm-review/latest/)

- [TCC (`test && commit || revert`)](https://incrementalelm.com/glossary/tcr/)

## What are you gaining from extracting a module?

- Protecting invariants
- Hiding internals
- Decoupling

- TDD helps drive module design.
- Experiment, but review your experiments before they become deeply ingrained.
- Pain in code is for sending a message.
- Technical debt isn't about "clean code". It's abstractions that serve what the code is doing. Abstractions are inherently expensive and a type of tech debt if they don't serve a purpose for your specific needs.

- Be proactive - immediately as soon as there is a clear way to make code better (not perfect, small improvement) - do it
- [Relentless, Tiny Habits](https://incrementalelm.com/tips/relentless-tiny-habits)
- [elm-test Elm Radio episode](https://elm-radio.com/episode/elm-test)
- Testing is helpful for identifying modules - see [keystone testing habit blog post](https://incrementalelm.com/tips/keystone-testing-habit/)
- Property based testing is a sign that something is a module - it has a clear property, which means you want to protect the internals
- It's okay to get it wrong, just don't get it all wrong up front with premature abstractions.
