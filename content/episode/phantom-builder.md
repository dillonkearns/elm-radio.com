---
type: episode
number: 40
title: Phantom Builder Pattern
description: Jeroen introduces the phantom builder pattern and how it enables new guarantees in Elm API design.
simplecastId: 4b95fe64-abe1-4fe1-b5e9-0e117ddcc8a6
---

- Phantom types (happens at compile time, not runtime)
- Helps avoid things like adding centimeters and inches
- [`ianmackenzie/elm-units`](https://package.elm-lang.org/packages/ianmackenzie/elm-units/latest/)
- Joël Quenneville's phantom types talk from Elm in the Spring [A Number by Any Other Name](https://www.youtube.com/watch?v=WnTw0z7rD3E)
- Extensible records
- Builder pattern
- [Jeroen's Hierarchy of Constraints](http://incrementalelm.com/jeroens-hierarchy)
- `elm-graphql` [`SelectionSet`](https://package.elm-lang.org/packages/dillonkearns/elm-graphql/latest/Graphql-SelectionSet#SelectionSet) scope type variable
- [Builder Pattern episode](https://elm-radio.com/episode/builder-pattern)
- Brian Hicks' builder pattern talk [Robot Buttons from Mars](https://www.youtube.com/watch?v=PDyWP-0H4Zo)
- `with` functions
- Phantom builder is a state machine for your types
- [`elm-review` Rule API](https://package.elm-lang.org/packages/jfmengels/elm-review/latest/Review-Rule) uses phantom builder

- [Phantom types discourse post on time package](https://discourse.elm-lang.org/t/typesafe-unified-date-and-time-package-using-phantom-record-types/5142) Simon Herteby
- Snapshot test in Elm review for expected error messages
- [Phantom Builder live stream episode](https://www.youtube.com/watch?v=NH4jF0-ZTtY)

## Possible operations with phantom extensible builders

- Add a new field
- Remove a field
- Change the type of a field
- Remove the previously existing phantom type and change it to an empty record (not extensible, just a hardcoded return type) i.e. Replace

## What you can do with phantom builder

- Require something to be always called
- Forbid something being called more than once
- Cause other constraints dynamically after calling something
- Make function calls mutually exclusive
- Enable a function only if another one has been called
