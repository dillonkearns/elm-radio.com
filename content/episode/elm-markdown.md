---
type: episode
number: 41
title: elm-markdown
description: We discuss the elm-markdown's approach to extensiblility, the markdown specification, and some advanced uses.
simplecastId: da511cd1-6cc2-43ad-9e03-f9f3cfd4aa97
---

- [`dillonkearns/elm-markdown`](https://package.elm-lang.org/packages/dillonkearns/elm-markdown/latest/)
- Markdown was built to be friendly to humans more than parsers. Example of a markdown quirk for human-friendliness: [numbered lists starting with `1` interrupt paragrpahs, starting with other numbers don't](https://github.github.com/gfm/#example-284)
- [Babelmark](https://babelmark.github.io/) helps compare output of different markdown implementations
- [Some parts of the markdown spec are ambiguous](https://babelmark.github.io/faq/#what-are-some-examples-of-interesting-divergences-between-implementations)
- [John Gruber created markdown (Daring Fireball)](https://daringfireball.net/projects/markdown/syntax)
- [Jeff Atwood pushed for CommonMark spec](https://blog.codinghorror.com/standard-markdown-is-now-common-markdown/)
- [CommonMark](https://commonmark.org/)
- [GitHub-Flavored Markdown (gfm)](https://github.github.com/gfm/) is a superset of CommonMark (Auto-links, Todo syntax, tables, etc.)
- [Bear notes app](https://bear.app/) (Mac only)

## `dillonkearns/elm-markdown`'s Core Tools for Extensibility

- [Custom Renderers](https://package.elm-lang.org/packages/dillonkearns/elm-markdown/latest/Markdown-Renderer)
- Html handlers ([example](https://github.com/dillonkearns/elm-markdown/blob/master/examples/src/CustomHtmlBlockSignupForm.elm))
- Transforming [parsed Markdown Blocks (AST)](https://package.elm-lang.org/packages/dillonkearns/elm-markdown/latest/Markdown-Block#Block)

- incrementalelm.com [code for getting back references](https://github.com/dillonkearns/incremental-elm-web/blob/63147e849ddcac63a9322f5b4283aaf30199e98e/src/Page/Page_.elm#L346-L378) from parsed markdown
- [Jeroen's Hierarchy of Constraints note](https://incrementalelm.com/jeroens-hierarchy)
- [Helpers for folding over Blocks and Inlines](https://package.elm-lang.org/packages/dillonkearns/elm-markdown/latest/Markdown-Block#transformations)
- [Extracting table of contents](https://github.com/dillonkearns/incremental-elm-web/blob/63147e849ddcac63a9322f5b4283aaf30199e98e/src/Page/Page_.elm#L346-L378) example
- [Discussion to formalize HTML parsing and error handling spec in `dillonkearns/elm-markdown`](https://github.com/dillonkearns/elm-markdown/discussions/93)
- Example of unintuitive raw HTML tag handling in markdown: [`<span>` closed by whitespace (ignores closing tag)](https://babelmark.github.io/?text=%3Cspan+style%3D%22background%3A+red%22%3E%0AThis+is+in+the+span%0A%0AThis+is+out+of+the+span%0A%0A%0A%3C%2Fspan%3E%0AThis+is+out+of+a+span)
- [Zettlekasten](https://zettelkasten.de/posts/overview/)
- Wikilinks
- [Foam Research](https://foambubble.github.io/foam/)
- [GFM Autolinks extension](https://github.github.com/gfm/#autolinks-extension-)
- [`elm-explorations/markdown`](https://package.elm-lang.org/packages/elm-explorations/markdown/latest/)
- Matthew Griffith's [`elm-markup`](https://package.elm-lang.org/packages/mdgriffith/elm-markup/latest/) package
- Matt's Oslo talk on fault tolerant parsing [A Markup for the Statically Typed](https://www.youtube.com/watch?v=8Zd3ocr9Di8)
- [`elm-optimize-level-2`](https://github.com/mdgriffith/elm-optimize-level-2/)
- [Shiki](https://github.com/shikijs/shiki)
- [Deckset](https://www.deckset.com/)
- [UnifiedJS markdown transformation ecosystem](https://unifiedjs.com/explore/)
- [`elm-markdown-transforms`](https://package.elm-lang.org/packages/matheus23/elm-markdown-transforms/latest/)
- Render to a function ([example](https://github.com/dillonkearns/elm-markdown/blob/18eb2ae45bac8c7f503adc9a077436b0e10e9721/examples/src/RenderingAFunction.elm))
- Scheme evaluator example ([demo](https://bburdette.github.io/cellme/mdcelldemo.html)) ([code](https://github.com/bburdette/cellme/blob/master/examples/src/MdMain.elm))
- [elm-pages 2.0 episode](https://elm-radio.com/episode/elm-pages-v2)
- Markdown announcement blog post [Extensible Markdown Parsing in Pure Elm](https://elm-pages.com/blog/extensible-markdown-parsing-in-elm)
- `#markdown` channel in [The Elm Slack](https://elmlang.herokuapp.com/)
- [Example of extracting title and description from parsed markdown](https://github.com/dillonkearns/elm-pages/blob/2d4350362a01b972cbe1aff3db062941554c8695/plugins/MarkdownCodec.elm#L82-L128)
- [Elm Online Meetdown](https://meetdown.app/group/10561/Elm-Online-Meetup)
- Submit a talk proposal to the [Elm Online Call for Speakers form](https://forms.gle/zX4huoLmrLJawn6M7)
