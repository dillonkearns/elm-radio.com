---
type: episode
number: 34
title: API Design Lessons
description: We share what we've learned from designing Elm APIs and how it applies when building applications and tools.
simplecastId: 33f863d4-2cc0-453b-8a62-8ef69dd798b6
---

- [Idiomatic Elm package guide](https://github.com/dillonkearns/idiomatic-elm-package-guide)
- [`dillonkearns/elm-package-starter`](https://github.com/dillonkearns/elm-package-starter)

## Lessons

1. Avoid unexpected or silent behavior
2. Give context/feedback when things go wrong so the user knows their change was registered, to enhance trust
3. Good errors aren't just for beginners - [Curb Cut Effect](https://en.wikipedia.org/wiki/Curb_cut_effect)
4. Sandi metz - code has a tendency to be duplicated - be a good role model - we're influenced by precedence
5. Matt Griffith - API design is holistic. It's a problem domain. Rethink from the ground up.
6. Learn from the domain and terms, but don't limit yourself to it when you can create better abstractions.
7. [Linus Torvalds' definition of elegance/good taste](https://github.com/mkirchner/linked-list-good-taste) - recognize two code paths as one. Reduce the number of concepts in your API when you can treat two things as one, then things compose more easily. [How Elm Code Tends Towards Simplicity](https://medium.com/@dillonkearns/how-elm-guides-towards-simplicity-3d34685dc33c).
8. You don't need a direct mapping of your domain, but start with the spec and terms. Leverage existing concepts, and have an economy of concepts. [Tereza's talk: elm-plot The Big Picture](https://www.youtube.com/watch?v=qTdXFRloYWU)
9. API design is a tool to help you solve problems.
10. There's a qualitative difference when you wire up feedback before you up front.
11. Avoid toy examples, use meaningful use cases to direct your design.
12. Design for concrete use cases, and drive changes through feedback from concrete use cases. Legal standing. [Better to do it right than to do it right now](https://twitter.com/evancz/status/928359227541798912) Evan's concept from the Elm philosophy. If you don't have a motivating use case, then wait. Extract APIs from real world code. It's okay for there to be duplication. Premature abstraction is the root of all evil. sSmplicity is the best thing you can do to anticipate future API design needs.
13. Come up with an API with the most benefits and the least pain points.
14. If there's something that you want to make really good, invest in giving it a good feedback mechanism.
15. Rich Hickey's talk [Hammock Driven Development](https://www.youtube.com/watch?v=f84n5oFoZBc). We don't design APIs, our extremely creative subconscious designs APIs - let your conscious brain do the hard work to put all the information in front of your subconscious so it can do what it does best. [elm-pages 2.0 screencast with Jeroen and Dillon](https://www.youtube.com/watch?v=EWnnv90t8_M).
16. Pay no attention to the man behind the curtain. Parse, Don't validate at the high level, but under the hood you may need a low level implementation.
17. Have a clear message/purpose - whether it's an API, or an internal module.
18. Take responsibility for user experiences.
