---
type: episode
number: 11
title: Parse, Don't Validate
description: We discuss the Alexis King's article and how those techniques apply in Elm.
simplecastId: 1301f577-3208-4534-884f-5d715af48ef5
---

- Alexis King's article [Parse, Don't Validate](https://lexi-lambda.github.io/blog/2019/11/05/parse-don-t-validate/)

> the difference between validation and parsing lies almost entirely in how information is preserved

- Shotgun parsing ([original academic paper](http://langsec.org/papers/langsec-cwes-secdev2016.pdf))
- Mixing processing and validating data

> Shotgun parsing is a programming antipattern whereby parsing and input-validating code is mixed with and spread across processing code—throwing a cloud of checks at the input, and hoping, without any systematic justification, that one or another would catch all the “bad” cases.

## Why the term "parse"?

> a parser is just a function that consumes less-structured input and produces more-structured output
> [...]
> some values in the domain do not correspond to any value in the range—so all parsers must have some notion of failure

- Conditionally return types
- Don't have to repeatedly check condition
- Look out for "lowest common denominator" built-in values being passed around (like empty String)
- `Maybe.withDefault` might indicate an opportunity to parse

Two ways to use this technique:

- Weaken return type
- Strengthen input type

* [Design by contract](https://en.wikipedia.org/wiki/Design_by_contract)

* Elm Radio [JSON decoders episode](https://elm-radio.com/episode/json-decoders)
