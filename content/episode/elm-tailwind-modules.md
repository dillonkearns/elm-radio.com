---
type: episode
number: 27
title: elm-tailwind-modules
description: We discuss using elm-tailwind-modules to build type-safe Tailwind views. It's composable, uses Elm's built-in dead code elimination, and is a delightful way to style Elm apps!
simplecastId: af3621fd-53d8-478f-954a-7fb9607dfe95
---

- Our guest: Philipp Krüger, aka `matheus23` ([github](https://github.com/matheus23/)) ([twitter](https://twitter.com/matheusdev23))
- [`matheus23/elm-tailwind-modules`](https://github.com/matheus23/elm-tailwind-modules)
- [`elm-reduce` (Philipp's Bachelor's thesis)](https://discourse.elm-lang.org/t/announcing-elm-reduce/3963)
- [TailwindCSS](https://tailwindcss.com/)
- [The Tailwind config file](https://tailwindcss.com/docs/configuration)
- [`elm-ui`](https://github.com/mdgriffith/elm-ui)
- [Sass/Scss](https://sass-lang.com/)
- [CSS inheritance](https://developer.mozilla.org/en-US/docs/Web/CSS/inheritance)
- Cohesion and coupling - don't separate things that need to be understood together
- [`monty5811/postcss-elm-tailwind`](https://github.com/monty5811/postcss-elm-tailwind) paved the path for Philipp's library
- [PurgeCSS](https://purgecss.com/)
- Philipp's library is a fork of [`justinrassier/postcss-elm-css-tailwind`](https://github.com/justinrassier/postcss-elm-css-tailwind)
- [`rtfeldman/elm-css`](http://github.com/rtfeldman/elm-css) (it's a drop-in replacement for [`elm/html`](https://package.elm-lang.org/packages/elm/html/latest))
- [CSS in JS](https://cssinjs.org/)
- [`miyamoen/elm-origami`](https://package.elm-lang.org/packages/miyamoen/elm-origami/latest/)
- [`matheus23/elm-default-tailwind-modules`](https://package.elm-lang.org/packages/matheus23/elm-default-tailwind-modules/latest/) is the best way to start (it's the generated `elm-tailwind-modules` code for the default TailwindCSS configuration)
- `elm-tailwind-modules` currently requires you to order your breakpoints from high to low ([see docs](https://github.com/matheus23/elm-tailwind-modules))
- [`tesk9/accessible-html`](https://package.elm-lang.org/packages/tesk9/accessible-html/latest/)
- [`github.com/dillonkearns/elm-pages-starter`](https://github.com/dillonkearns/elm-pages-starter)
- [`elm-pages-tailwind-starter`](https://github.com/dillonkearns/elm-pages-tailwind-starter)
- [CSS grid](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_Grid_Layout)
- [Elm Radio `elm-ui` episode](https://elm-radio.com/episode/elm-ui)
- [`miniBill/elm-ui-with-context`](https://package.elm-lang.org/packages/miniBill/elm-ui-with-context/latest/)
- [TailwindUI](http://tailwindui.com/) - a paid catalog of TailwindCSS templates and widgets/components
- [`elm-ts-interop` landing page](http://elm-ts-interop.com/) (built with `elm-tailwind-modules`)
- [html-to-elm.com](https://html-to-elm.com/)
- elm-review rule for html-to-elm.com, [`dillonkearns/elm-review-html-to-elm`](https://package.elm-lang.org/packages/dillonkearns/elm-review-html-to-elm/latest/)
- [Refactoring UI book](https://refactoringui.com/book/)
- React presentational components vs ???
- [This blog post talks about the View Objects pattern](https://codeclimate.com/blog/7-ways-to-decompose-fat-activerecord-models/) in Object-Oriented Programming
- [Elm Radio Incremental Steps episode](https://elm-radio.com/episode/incremental-steps)
- [FullStack Radio podcast](https://fullstackradio.com/)
- [A FullStack episode about the TailwindCSS philosophy](https://podcasts.google.com?feed=aHR0cHM6Ly9mZWVkcy50cmFuc2lzdG9yLmZtL2Z1bGwtc3RhY2stcmFkaW8%3D&episode=NDQzNjA3MmYtODZmNi00MjhkLWIwYTUtYjVlYjJhN2M2NWQ1)
- `elm-css`'s [`fromUnstyled`](https://package.elm-lang.org/packages/rtfeldman/elm-css/latest/Html-Styled#fromUnstyled) and [`toUnstyled`](https://package.elm-lang.org/packages/rtfeldman/elm-css/latest/Html-Styled#toUnstyled) are helpful for incremental adoption (start refactoring from the leaves)
