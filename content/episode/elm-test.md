---
type: episode
number: 10
title: elm-test
description: We discuss the fundamentals of test-driven development, and the testing tools in the Elm ecosystem.
simplecastId: 98c70281-8162-487f-a8ae-51c7e90dae69
---

## `elm-test` Basics
* [elm-test](https://www.npmjs.com/package/elm-test) NPM package
* [`elm-explorations/test`](https://package.elm-lang.org/packages/elm-explorations/test/latest/) Elm package
* [`elm-test init`](https://github.com/rtfeldman/node-test-runner#init) command
* Running `elm-test` finds exposed values of type [`Test`](https://package.elm-lang.org/packages/elm-explorations/test/latest/Test#Test)

## TDD Principles
* Testing in Elm is easier because it's just expectations of input to output (deterministic)
* TDD is a design practice too
* [Programming by Intention](https://en.wikipedia.org/wiki/Intentional_programming)
* Writing test first makes code testable & decoupled
* [Red, green, refactor](https://thoughtbot.com/upcase/videos/red-green-refactor-by-example)
* [YAGNI](https://www.martinfowler.com/bliki/Yagni.html)
* "Make the change easy, then make the easy change"
* Kent Beck's [**TDD by Example**](https://www.amazon.com/Test-Driven-Development-Kent-Beck/dp/0321146530)
* Here's a [staring template of a code kata in Elm](https://github.com/dillonkearns/elm-katas/blob/f98f2d11292d88d5c1e287029c7241207f97b0e5/tests/TennisTest.elm) that you can use to practice
* Emily Bache has many more code katas you can practice [on her GitHub](https://github.com/emilybache)

## Fuzz Testing
* Also known as Property-Based Testing
* Martin Janiczek's [`elm-minithesis`](https://github.com/Janiczek/elm-minithesis) project
* `elm-test`'s view testing API includes [`Test.Html.Query`](https://package.elm-lang.org/packages/elm-explorations/test/latest/Test-Html-Query), [`Test.Html.Selector`](https://package.elm-lang.org/packages/elm-explorations/test/latest/Test-Html-Selector), and [`Test.Html.Event`](https://package.elm-lang.org/packages/elm-explorations/test/latest/Test-Html-Event)
View objects

* [Testing pyramid](https://martinfowler.com/articles/practical-test-pyramid.html)
* Mocking and stubbing are not needed or possible in Elm
* Order dependent test helper in Ruby: [`i_suck_and_my_tests_are_order_dependent`](http://www.ruby-doc.org/stdlib-1.9.3/libdoc/minitest/unit/rdoc/MiniTest/Unit/TestCase.html#method-c-i_suck_and_my_tests_are_order_dependent-21)

## When to Use Types or Tests
* Jeroen's [Safe Unsafe Operations](https://jfmengels.net/safe-unsafe-operations-in-elm/) blog post
* Richard Feldman's talk on [Types and Tests](https://www.youtube.com/watch?v=51O63Sb-Ae0)
* [Make Impossible States](https://www.youtube.com/watch?v=IcgmSRJHu_8)

## Should you test implementation details?
* [Discourse thread discussing testing internals](https://discourse.elm-lang.org/t/not-exposing-internals-hurts-testability/6014)
* Think in terms of a modules responsibility 

## Higher-Level Testing in Elm
[`elm-program-test`](https://package.elm-lang.org/packages/avh4/elm-program-test/latest/)
Martin Janiczek's [elm Europe talk on testing Msg's](https://www.youtube.com/watch?v=baRcusTHc8E) with [`ArchitectureTest`](https://package.elm-lang.org/packages/Janiczek/architecture-test/latest/)
* Richard [`test-update`](https://github.com/rtfeldman/test-update) package
