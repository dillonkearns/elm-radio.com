---
type: episode
number: 40
title: Phantom Builder Pattern
description: TODO
simplecastId: 4b95fe64-abe1-4fe1-b5e9-0e117ddcc8a6
---

- Phantom types (happens at compile time, not runtime)
- Helps avoid things like adding cm and in
- Elm units
- Joel's phantom units talk elm in spring
- Extensible records
- Builder pattern
- Jeroen's hierarchy of constraints
- Elm graphql SelectionSet scope type variable
- Builder pattern episode
- Brian robot buttons talk
- With functions
- Phantom builder is a state machine for your types
- Elm review docs use phantom builder
- Extensible records
- Real world phantom builder examples
- Ellie example of button ingerarvitiy needed?
- Phantom types discourse post on time package Simon hertby
- Snapshot test in Elm review for expected error messages
- Phantom builder live stream

Possible operations with phantom extensible builders

- Add a new field
- Remove a field
- Change the type of a field
- Remove the previously existing phantom type and change it to an empty record (not extensible, just a hardcoded return type) i.e. Replace

What you can do

- Require something to be always called
- Forbid something being called more than once
- Cause other constraints dynamically after calling something
- Make function calls mutually exclusive
- Enable a function only if another one has been called
