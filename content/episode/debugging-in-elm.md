---
type: episode
number: 30
title: Debugging in Elm
description: We talk about our favorite debugging techniques, and how to make the most of Elm's guarantees when debugging.
simplecastId: cb2459ab-8c73-414e-8820-144754834d1c
---

- Rubber ducking
- Lay out your assumptions explicitly
- Veritasium video [The Most Common Cognitive Bias](https://www.youtube.com/watch?v=vKA4w2O61Xo)

## Elm Debugging techniques

- `Debug.todo`
- Frame then fill in
- Annotation let bindings
- [Using nonsense names](https://www.digdeeproots.com/articles/get-to-obvious-nonsense/) as a step
- Elm review rule to check for nonsense name

## Hardcoded values vs debug.todo

- Todos don't allow you to get feedback by running your code
- TDD
- Fake it till you make it
- Simplest thing that could possibly work
- Joël Quenneville's article [Classical Reasoning and Debugging](https://thoughtbot.com/blog/classical-reasoning-and-debugging)
- Debugging is like pruning a tree

## Breaks

- Take a walk. Step away from the keyboard when you're grinding on a problem
- [sscce.org](http://sscce.org/) (Short, Self Contained, Correct (Compilable), Example)
- Create a smaller reproduction of the problem
- Reduce the variables, you reduce the noise and get more useful feedback
- Reasoning by analogy from Joël's post
- [Elm debug log browser extension](https://github.com/kraklin/elm-debug-extension)
- `node --inspect`
- [`elm-test-rs`](https://github.com/mpizenberg/elm-test-rs)

## `Debug.log` in unit tests

- `Test.only` for running just one `test` or `describe`
- Put `Debug.log`s in each path of an if or case expression
- Use the browser elm debugger to inspect the model
- [Scaling Elm Application episode](https://elm-radio.com/episode/scaling-elm-apps)
- Narrow down your search space with Elm types
- [Parse, Don't Validate episode](https://elm-radio.com/episode/parse-dont-validate)
- Tiny steps help you prune the tree
- [Exploratory Testing](https://martinfowler.com/bliki/ExploratoryTesting.html)
- Wrap early, unwrap late
