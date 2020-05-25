---
type: episode
number: 6
title: elm/parser
description: We discuss parsers, how to build them in Elm, and how to try to make your error messages as nice as Elm's.
publishAt: 2020-05-25T11:00:00+0000
simplecastId: 37115448-9cdc-4f34-a7fa-5d13044a12cb
---

## What is a parser?

- yacc/lex
- AST (Abstract Syntax Tree) vs. CST (Concrete Syntax Tree)
- JSON decoding vs. parsing
- JSON decoding is validating a data structure that has already been parsed. Assumes a valid structure.
- [`elm/parser`](https://package.elm-lang.org/packages/elm/parser/latest/)
- Haskell [parsec](https://hackage.haskell.org/package/parsec) library - initially used for the Elm compiler, now uses custom parser

## What is a parser?

- One character at a time
- Takes input string, turns it into structued data (or error)

## Comitting 

- Backtrackable parsers
- [`chompIf`](https://package.elm-lang.org/packages/elm/parser/latest/Parser#chompIf) and [`chompWhile`](https://package.elm-lang.org/packages/elm/parser/latest/Parser#chompWhile)
- [`Parser.oneOf`](https://package.elm-lang.org/packages/elm/parser/latest/Parser#oneOf)

## Benchmarking

- [`elm-explorations/benchmark`](https://package.elm-lang.org/packages/elm-explorations/benchmark/latest/)
- Benchmark before making assumptions about where performance bottlenecks are
- Write unit tests for your parser
- [GFM table parsing live stream](https://www.youtube.com/watch?v=5Py9cKXMUrE)
- [`Parser.succeed`](https://package.elm-lang.org/packages/elm/parser/latest/Parser#succeed)

## Elm regex vs elm parser

Indications that you might be better off with parser

- Lots of regex capture groups
- Want very precise error messages

## Getting source code locations

- [`Parser.getRow`](https://package.elm-lang.org/packages/elm/parser/latest/Parser#getRow) and [`getCol`](https://package.elm-lang.org/packages/elm/parser/latest/Parser#getCol)
- [`Parser.getSource`](https://package.elm-lang.org/packages/elm/parser/latest/Parser#getSource)

## Parser.loop

- [Loop docs](https://package.elm-lang.org/packages/elm/parser/latest/Parser#loops) in `elm/parser`
- Looping allows you to track state and parse groups of expressions
- Loop over repeated expression type, tell it termination condition with [`Step` type](https://package.elm-lang.org/packages/elm/parser/latest/Parser#Step) (`Loop` and `Done`)

## Error Messages

- You can fail with Parser.problem
- [Parser.Advanced](https://package.elm-lang.org/packages/elm/parser/latest/Parser-Advanced) module is designed to give you more precise context and error messages on failure
- [Parser.Advanced.inContext](https://package.elm-lang.org/packages/elm/parser/latest/Parser-Advanced#inContext)

## Getting Started with a Parser Project

- Write lots of unit tests with [`elm-test`](https://package.elm-lang.org/packages/elm-explorations/test/latest/)!

There's likely a specification doc if you're parsing a language or formal syntax

- [CommonMark Spec](https://spec.commonmark.org/0.29)
- [GitHub-Flavored Markdown Spec](https://github.github.com/gfm/)
- dillonkearns/elm-markdown [test results directory](https://github.com/dillonkearns/elm-markdown/tree/master/test-results) from executing spec examples

Look at examples of parser projects

- [`dillonkearns/elm-markdown`](https://github.com/dillonkearns/elm-markdown)
- [`elm-in-elm`](https://github.com/elm-in-elm/compiler) parser
- [elm-in-elm conference talk](https://www.youtube.com/watch?v=62khGXfh8zg)
- [`mdgriffith/elm-markup`](https://github.com/mdgriffith/elm-markup) - good reference for parsing, fault-tolerant parsing, and giving nice error messages
- Tereza's [YAML parser](https://github.com/terezka/yaml/)
- Tereza's elm conf talk ["Demystifying Parsers"](https://www.youtube.com/watch?v=M9ulswr1z0E)
- Jeroen's [elm/parser Ellie](https://ellie-app.com/8L2MDB9t9vWa1)
- "It's not hacking if you have tests."

Look at elm/parser docs and resources

- elm/parser project's [semantics document](https://github.com/elm/parser/blob/master/semantics.md) describes backtrackable behavior in detail