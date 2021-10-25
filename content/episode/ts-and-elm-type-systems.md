---
type: episode
number: 42
title: Comparing TypeScript and Elm's Type Systems
description: TypeScript and Elm have very different type systems with different goals. We dive into the different features and the philosophy behind their different designs.
simplecastId: b40022b8-fa62-4586-aed6-eaf76aa63f59
---

- TypeScript and Elm have different goals
- [Soundness is not a goal of the TypeScript type system](https://github.com/Microsoft/TypeScript/issues/9825#issuecomment-234115900)
- [TypeScript Design Goals (and non-goals)](https://github.com/Microsoft/TypeScript/wiki/TypeScript-Design-Goals)
- TypeScript's [`any` type](https://www.typescriptlang.org/docs/handbook/2/everyday-types.html#any)
- [Nominal vs structural typing](https://flow.org/en/docs/lang/nominal-structural/)

## TypeScript's `any` vs. Elm's `Debug.todo`

TypeScript's `any` essentially "turns off" type checking in areas that any passes through.

In Elm:

- You can get a type that could be anything with `Debug.todo`, but you can't build your app with `--optimize` if it has Debug.todo's in it
- You will still get contradictions between inconsistent uses of a type that could be anything ([see this Ellie example](https://ellie-app.com/fFzSZnSGPxNa1))

This [Ellie example](https://ellie-app.com/fFzSZnSGPxNa1) (with compiler error as expected) and this [TypeScript playground example](https://www.typescriptlang.org/play?#code/GYVwdgxgLglg9mABMOcAUMoFMC2AuRAQzAE8BKAgNzhgBNEBvAWAChFEwstaBnAZSgAnGGADmGbDjKt2nbjwByIHACMsgibmksAvq1ahIsBBy68BwsZvyIeQkaLKN9ul4ejwkc3ktXrrBGDKaoJOzGyIrDpAA) (with no error) show the difference.

- [`any` can not be used in places that take `never`](https://www.typescriptlang.org/play?#code/GYVwdgxgLglg9mABGApigJgZwHIoG4oBOAFHgIYA2IKAXMvkQJSIDeAsAFCcC+nnokWAkQoAHmQC2ABwopiqAoQBqlanQVEANIjJgAniqq0d+5uw6JL9DDgYkNy1Skacr1rLkXFdBpy468HEA)
- `any` vs [`unknown`](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-3-0.html#new-unknown-top-type)
- `JSON.parse` returns `any`, as do many core and published typings
- [`io-ts`](https://github.com/gcanti/io-ts) lets you validate JSON similar to JSON decoders in Elm
- [Definitely Typed](https://github.com/DefinitelyTyped/DefinitelyTyped) (published type definitions for NPM packages)
- [Definitely Typed search](https://www.typescriptlang.org/dt/search?search=)
- [`noImplicitAny`](https://www.typescriptlang.org/tsconfig#noImplicitAny)
- [TypeScript `strict mode in tsconfig](https://www.typescriptlang.org/tsconfig#strict)
- Dillon's post [TypeScript's Blind Spots](https://incrementalelm.com/typescript-blind-spots/)
- JS semantics allow types that may not be intended (like adding a string `+` object, `'' + {} === '[object Object]'`)
- Function parameters are inferred to be `any` regardless of implementation if they aren't given an explicit type
- [Type narrowing](https://www.typescriptlang.org/play#example/type-widening-and-narrowing)
- [TypeScript has untagged unions (just called Unions)](https://www.typescriptlang.org/docs/handbook/2/everyday-types.html#union-types) - in Elm, there are only tagged unions (called Custom Types)
- Undefined vs null
- [TypeScript's Void type](https://www.typescriptlang.org/docs/handbook/basic-types.html#void)
- TypeScript doesn't have checked exceptions like Java (there is [a discussion about this on GitHub](https://github.com/microsoft/TypeScript/issues/13219)) - Elm only has explicit errors as data that must be handled exhaustively like other data types
- Discriminated unions vs Elm custom types
- [Literal types](https://www.typescriptlang.org/docs/handbook/2/everyday-types.html#literal-types)
- TypeScript allows number literal values, [but arithemtic expressions return generic `number` values instead of literal types](https://www.typescriptlang.org/play?#code/GYVwdgxgLglg9mABAgpgeQE4BUDucAUAbgIYA2IKiAXIgIyIA+iATAJSIDeAsAFC8C+vXqky4CtVsLDpsefGykyx+AMySeI2eMQBqOuqA)
- [Enums](https://www.typescriptlang.org/docs/handbook/enums.html)
- [Branded types in TypeScript](https://basarat.gitbook.io/typescript/main-1/nominaltyping) vs opaque types
- Elm Radio [Opaque Types episode](https://elm-radio.com/episode/intro-to-opaque-types)
- Switch statements are not exhaustive - you can add an eslint rule to check that (or the never trick, assert unreachable)
- [Key of operator in TypeScript](https://www.typescriptlang.org/docs/handbook/2/keyof-types.html)
- [TypeScript's type system can do some cool things that Elm can't (for better and for worse)](https://incrementalelm.com/typescript-types-can-do-some-cool-things-that-elm-cant/)
- [Prisma](https://www.prisma.io/)
- [Prisma advanced TS meetup talks](https://www.youtube.com/c/PrismaData/search?query=typescript)
- [Tuples in TypeScript are just arrays and use narrowing](https://www.typescriptlang.org/docs/handbook/2/objects.html#tuple-types) - [Tuple in Elm](https://package.elm-lang.org/packages/elm/core/latest/Tuple) is a specific type
- [`elm-ts-interop`](https://elm-ts-interop.com/setup)
- [TypeScript handbook](https://www.typescriptlang.org/docs/handbook/intro.html) on official site
