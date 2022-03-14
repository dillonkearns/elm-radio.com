---
type: episode
number: 52
title: Category Theory in Elm with Joël Quenneville
description: Joël Quenneville joins us to help us distill down Category Theory patterns and explore what value it brings us as Elm developers.
simplecastId: 1d6339b3-6616-4812-a58e-8092abde033b
---

- Joël Quenneville ([Twitter](https://twitter.com/joelquen))
- [Elm's Universal Pattern episode](https://elm-radio.com/episode/universal-pattern)
- `List.concatMap` is the same pattern as `andThen` under a different name
- `andThen identity` can be used to flatten something
- Dillon's [Combinators article](https://incrementalelm.com/combinators)
- [Martin Janiczek's `elm-list-cartesian` package](https://package.elm-lang.org/packages/Janiczek/elm-list-cartesian/latest/) gives two valid `map2` implementions for `List`
- Monoid - need a way of having something empty, and way to combine two things - for example addition for numbers starting with 0
- Jeroen's [`elm-review-simplify` package](https://package.elm-lang.org/packages/jfmengels/elm-review-simplify/latest/)

More of Joël's distillation of category theory ideas:

- [Running out of maps](https://thoughtbot.com/blog/running-out-of-maps) (applicatives)
- [The Mechanics of Maybe](https://thoughtbot.com/blog/maybe-mechanics) (taking maybe apart and putting it back together)
- [Two ways of looking at map functions](https://thoughtbot.com/blog/two-ways-of-looking-at-map-functions) (functors)
- [Elm's universal pattern](https://thoughtbot.com/blog/elms-universal-pattern) (applicatives)
- [Inverting a binary tree](https://www.youtube.com/watch?v=dSMB3rsufC8) (folding, catamorphisms)
- [Joël's directory of blog posts on the ThoughtBot blog](https://thoughtbot.com/blog/authors/joel-quenneville)
