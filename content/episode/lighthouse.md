---
type: episode
number: 18
title: Lighthouse Scores
description: Lighthouse can show you a lot of low-hanging fruit to improve your site's performance. It also points out ways to make your site more accessible, follow best practices, and perform better with SEO.
simplecastId: c42759fb-69a4-400d-9706-bcc96d9e3a99
---

## Performance metrics

- [First Contentful Paint](https://web.dev/first-contentful-paint/)
- [Time to Interactive](https://web.dev/interactive/)
- [Cumulative Layout Shift](https://web.dev/cls/)

## Best practices

- [Lighthouse SEO Audits](https://web.dev/lighthouse-seo/)
- [Lighthouse Best Practices Audits](https://web.dev/lighthouse-best-practices/)

## Performance best practices

- CDN
- Netlify

### Image Optimization

- Cloudinary
- loading=lazy
- SVG

## Icons

- Apple touch and other icons to add to `<head>`
- Some resources on icons
- [What the apple touch icons mean](https://webhint.io/docs/user-guide/hints/hint-apple-touch-icons/)
- [Google web.dev resource on apple touch icons](https://web.dev/apple-touch-icon/)
- [manifest.json](https://developer.mozilla.org/en-US/docs/Mozilla/Add-ons/WebExtensions/manifest.json)

## PWAs

- [Progressive Web Apps](https://developer.mozilla.org/en-US/docs/Web/Progressive_web_apps)
- Must be HTTPS
- [About service workers](https://developers.google.com/web/fundamentals/primers/service-workers)
- [Stale while revalidate service worker cache policy](https://developers.google.com/web/tools/workbox/modules/workbox-strategies#stale-while-revalidate)
- [Workbox](https://developers.google.com/web/tools/workbox)
- elm-starter

## Performance

- [Elm optimization instructions](https://github.com/mdgriffith/elm-optimize-level-2/blob/HEAD/notes/minification.md) for using Terser, the `--opimize` flag, and `elm-optimize-level-2`
- Dev tools performance tab
- Ju Liu's article, [Performant Elm](https://juliu.is/performant-elm/), on analyze Elm performance using Chrome Dev Tools
- [HTTP2 Push is dead](https://evertpot.com/http-2-push-is-dead/)
- [Using preload tags](https://developer.mozilla.org/en-US/docs/Web/HTML/Preloading_content)

- Here's an [in-depth conference talk on different script tag techniques](https://www.youtube.com/watch?v=tr6aHw8I32M). Ishows the differences between different ways to load script tags, including using `async`, `defer`, and in HTML `<head>` vs. `<body>`

## SEO

- [meta viewport tag](https://web.dev/viewport/)
- [Axe accessibility tools](https://www.deque.com/axe/)
- [Canonical URLs](https://developers.google.com/search/docs/advanced/crawling/consolidate-duplicate-urls#expandable-1)
- [OpenGraph tags](https://www.opengraph.xyz/)
- [Lighthouse accessibility audits](https://web.dev/lighthouse-accessibility/)

## Resources

- [Lighthouse netlify plugin](https://github.com/netlify-labs/netlify-plugin-lighthouse)
- [web.dev learn section](https://web.dev/learn/)
