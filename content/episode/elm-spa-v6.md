---
type: episode
number: 35
title: elm-spa v6
description: Ryan Haskell-Glatz joins us to discuss the latest version of elm-spa, including authenticated pages and the updated file-based router.
simplecastId: 8b9dc9b3-7055-4b04-8a02-81f276a48b21
---

- Ryan Haskell-Glatz ([Twitter](https://twitter.com/rhg_dev)) ([GitHub](http://github.com/ryannhg))
- [`elm-spa` V5 Docs](https://v5.elm-spa.dev/)
- [`elm-spa` v5 episode](https://elm-radio.com/episode/elm-spa)

## Key new features in v6

[Protected pages](https://www.elm-spa.dev/examples/04-authentication)

- Provide/redirect protected custom type
- Eject workflow
- [Vuepress](http://vuepress.vuejs.org/)
- [`elm-program-test` docs site](https://elm-program-test.netlify.app/)
- Can Eject not found page
- Eject workflow stops generating files when they're ejected
- [File-based routing in `elm-spa`](https://www.elm-spa.dev/guide/02-routing)
- Inspired by [Nuxt](http://nuxtjs.org/)
- [Page builder API](https://www.elm-spa.dev/guide/03-pages) (like browser sandbox)
- No more int or string in url

- [`elm-pages` 2.0 routing](https://deploy-preview-176--elm-pages.netlify.app/docs/file-based-routing) and splat routes
- [`elm-spa` add command](https://www.elm-spa.dev/guide/01-cli#elm-spa-add)
- [`elm-live`](https://github.com/wking-io/elm-live)
- [Vite](https://vitejs.dev/)
- [`elm-spa` View module](https://www.elm-spa.dev/guide/06-views)
- [UI namespace in elm-spa docs repo](https://github.com/ryannhg/elm-spa/blob/1a0b97f8c7ff983028cdfe669a6ac01e36ac3561/docs/src/UI.elm) has a shared page helper function for building the shared header/footer
- [Shared module](https://www.elm-spa.dev/guide/05-shared-state)
- elm-spa 6 has fewer ignored arguments compared to v5 - now wired through in page top level function and you can wire to update, init, etc.
- Effect pattern - `elm-spa` v6 has an ejectable `Effect` module
- [`elm-real-world` SPA example](https://github.com/ryannhg/elm-spa-realworld) (`elm-spa-example` using `elm-spa` framework)
- [elm-spa.dev](https://elm-spa.dev/)
- [`elm-program-test` example folder](https://github.com/ryannhg/elm-spa/tree/main/examples/06-testing)
- [Blissfully jobs](https://www.blissfully.com/careers/)
- [`#elm-spa-users` channel](https://elmlang.slack.com/archives/CSN4WM1RV) on the Elm Slack
