---
type: episode
number: 1
title: Getting started with elm-pages
description: elm-pages let's you build fast, SEO-friendly static sites with pure Elm. We go over the core concepts, explain Static Sites vs. JAMstack, and give some resources for getting started with elm-pages.
publishAt: 2020-04-08T13:00:00+0000
simplecastId: ca009f6e-1710-4518-b869-ca34cb0b7d17
---

[elm-pages](https://github.com/dillonkearns/elm-pages) hydrates into a full Elm app. It solves similar problems to what [GatsbyJS](https://www.gatsbyjs.org/) solves in the ReactJS ecosystem.

## Static site generators with JS-free output

[https://korban.net/elm/elmstatic/](https://korban.net/elm/elmstatic/)  
[https://jekyllrb.com/](https://jekyllrb.com/)  
[Eleventy](https://11ty.dev/)

## Meta Tags

[Open Graph tags](https://ogp.me/)

## Asset management with elm-pages (CSS vs. SASS,etc.)

[Github issue](https://github.com/dillonkearns/elm-pages/issues/70) discussing using the [Unix Toolchain Philosophy](https://en.wikipedia.org/wiki/Unix_philosophy) in the context of keeping elm-pages focused on primitive assets for elm apps

Compared to [extending the Gatsby webpack config](https://www.gatsbyjs.org/docs/add-custom-webpack-config/)

SOLID [Open-Closed Principle](https://en.wikipedia.org/wiki/Open%E2%80%93closed_principle)

[elm-pages showcase](https://elm-pages.com/showcase)

Chandu's art showcase (built with elm-pages) - [https://tennety.art/](https://tennety.art/)

### Headless CMSes vs. monolothic site providers

[https://www.sanity.io/](https://www.sanity.io/)  
contentful.com  
[https://airtable.com/](https://airtable.com/)  
netlifycms.org

CDN hosting provider [Netlify](http://netlify.com/)

### Static Site Generators and The JAMstack

[https://jekyllrb.com/](https://jekyllrb.com/) - static site builder in Ruby - perhaps the first static site generator?  
[Eleventy](https://11ty.dev/) - spritual successor to Jekyll - but more flexible  
More info on [what exactly is the JAMstack?](https://jamstack.org/)

### Getting started with elm-pages

[elm-pages-starter repo](https://elm-pages-starter.netlify.com/)

### elm-pages vs. elm/browser

[Pages.Platform.application](https://package.elm-lang.org/packages/dillonkearns/elm-pages/4.0.0/Pages-Platform#application)

### The elm-pages StaticHttp API

[StaticHttp Docs](https://package.elm-lang.org/packages/dillonkearns/elm-pages/4.0.0/Pages-StaticHttp) (there's a description of when and why you would use this compared to elm/http)

elm-pages.com blog post [A is for API](https://elm-pages.com/blog/static-http) - talks about StaticHttp and its lifecycle, including some example code.

### Core Concepts

* SEO - [elm-pages SEO API docs](https://package.elm-lang.org/packages/dillonkearns/elm-pages/4.0.0/Head-Seo)
* Secrets - [docs](https://package.elm-lang.org/packages/dillonkearns/elm-pages/latest/Pages-Secrets)
* [Section in StaticHttp blog post](https://elm-pages.com/blog/static-http#lessboilerplate) about how you don't use Msgs for your StaticHttp data
* generateFiles hook

[Incremental Elm Live - Twitch streaming series](https://incrementalelm.com/live)

### Where to learn more

* elm-pages.com
* Join the [Elm slack](https://elmlang.herokuapp.com/) and say hello in the elm-pages channel!