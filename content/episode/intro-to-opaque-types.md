---
type: episode
number: 2
title: Intro to Opaque Types
description: Opaque Types are a fancy way of saying "custom type with a private constructor." We talk about the basics, how to get started, and some patterns for using Opaque Types.
publishAt: 2020-04-08T13:00:00+0000
simplecastId: fcdfee63-05b5-49af-b854-da4b814b98e6
---
## Opaque Types

Some patterns

* Runtime validations - conditionally return type, wrapped in Result or Maybe
* Guarantee constraints through the exposed API of the module (like PositiveInteger or AuthToken examples)

## Package-Opaque Modules

Example - the [Element](https://package.elm-lang.org/packages/mdgriffith/elm-ui/latest/Element#Element) type in elm-ui.  
Definition of the [Element type alias](https://github.com/mdgriffith/elm-ui/blob/53a2732d9533c242c7690e16506b673af982032a/src/Element.elm#L325-L326)

[elm-ui's elm.json file](https://github.com/mdgriffith/elm-ui/blob/1.1.5/elm.json#L7-L17) does not expose the internal module where the real Element type is defined.

Example from [elm-graphql](https://github.com/dillonkearns/elm-graphql) codebase - [CamelCaseName opaque type](https://github.com/dillonkearns/elm-graphql/blob/master/generator/src/Graphql/Parser/CamelCaseName.elm)
