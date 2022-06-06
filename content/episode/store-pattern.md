---
type: episode
number: 58
title: Elm Store Pattern
description: Martin Janiczek joins us to discuss a pattern for declaratively managing loading state for API data across page changes.
simplecastId: 11469d21-f37b-48bd-a195-34cc22e73e1e
---

- Martin Janiczek ([github](https://github.com/Janiczek)) ([twitter](https://twitter.com/janiczek)) ([youtube](https://www.youtube.com/c/MartinJaniczek))
- Martin's [Store Pattern talk](https://www.youtube.com/watch?v=BCmNX2Tx5xY)
- [Store Pattern example GitHub repo](https://github.com/Janiczek/elm-store-pattern)
- Gizra fetch pattern blog post [elm-fetch, and Easier HTTP Requests to Reason with](https://www.gizra.com/content/elm-fetch/)
- [Gizra `elm-fetch` package](https://package.elm-lang.org/packages/Gizra/elm-fetch/latest/)
- [`RemoteData` package](https://package.elm-lang.org/packages/krisajenkins/remotedata/latest/)
- RemoteData blog post [How Elm Slays a UI Antipattern](http://blog.jenkster.com/2016/06/how-elm-slays-a-ui-antipattern.html)
- [`elm-program-test`](https://package.elm-lang.org/packages/avh4/elm-program-test/latest/) is useful for integration testing data loading
- [`elm-suspense`](https://github.com/rogeriochaves/elm-suspense) proof-of-concept repo
- Okay to use Store pattern for mutations, just kick them off outside of `dataRequests`
- Defunctionalization
- Wrap early, unwrap late
- Derive from source of truth instead of storing derived data
