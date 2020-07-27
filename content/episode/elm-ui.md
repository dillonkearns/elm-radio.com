---
type: episode
number: 9
title: elm-ui
description: We discuss the fundamentals of elm-ui, and how to decide if it's the right fit for your team.
publishAt: 2020-07-27T11:00:00+0000
simplecastId: 4e837fef-f233-4471-9f0d-ef3246985e77
---

* [`elm-ui` package](https://package.elm-lang.org/packages/mdgriffith/elm-ui/latest/)
* Fewer overlapping ways to express views
* [`Element.padding`](https://package.elm-lang.org/packages/mdgriffith/elm-ui/latest/Element#padding) (no concept of margin)

## Previously called style-elements
* There used to be a notion of a [single type defining all possible styles](https://github.com/mdgriffith/style-elements/blob/5.0.1/examples/Basic.elm#L14-L24)
* Latest `elm-ui` simplifies that by using only inline styles. You build your own abstractions with vanilla Elm functions/modules etc.
* [`Element`](https://package.elm-lang.org/packages/mdgriffith/elm-ui/latest/Element#Element) type is the equivalent of the `Html` type from `elm/html`

* [`elm-css` package](https://package.elm-lang.org/packages/rtfeldman/elm-css/latest/)
* [Mobster app](http://mobster.cc/)


## Escape hatches
* `Element.html` works at leaf nodes, but `elm-ui` in general doesn’t mix with plain html
* `Element.htmlAttribute`

* Refactoring is a huge asset for a team, so much easier than css refactoring
* Doesn’t expose all the css tricks directly, sometimes you need escape hatches to access those

## Responsiveness
* Pass in window size from your Elm model
* Doesn’t use media queries, so that approach doesn't play well with with pre-rendered html like in [`elm-pages`](https://elm-radio.com/episode/getting-started-with-elm-pages)
* [`classifyDevice`](https://package.elm-lang.org/packages/mdgriffith/elm-ui/latest/Element#classifyDevice) is an optional helper for responsiveness



## Semantic html
* Express layout with `Element.row`, `column`, `el`
* Semantic HTML is independent from layout. Set with attributes using the `Element.Region` module.

## Wrapping
* `Element.paragraph` uses text wrapping

## `em`/`rem`
* `elm-ui` doesn't expose access to `rem` and `em` units to simplify the mental model and reduce overlapping ways to express something

## Cookbooks/examples
Lucas Payr's [`elm-ui-widgets`](https://package.elm-lang.org/packages/mdgriffith/elm-ui/latest/Element#classifyDevice)
Alex Korban's [`elm-ui` patterns](https://discourse.elm-lang.org/t/announcing-elm-ui-patterns/5690
)

## Debugging `elm-ui` views
* `Element.explain` gives you highlights around nested elements
* Inspecting developer tools doesn't help much with `elm-ui`, but `elm-ui` is much more traceable because it doesn't have layout cascading like CSS

## Resources
* Matt's `elm-ui` announcement talk at Elm Europe https://www.youtube.com/watch?v=NYb2GDWMIm0 (was about `elm-style-elements`, but still worth a watch)
* Matt's more recent `elm-ui` conference talk https://www.youtube.com/watch?v=Ie-gqwSHQr0
* Richard Feldman's talk [CSS as Bytecode](https://www.youtube.com/watch?v=bt1TzVngOqY) (uses style-elements, but it's a great intro tutorial on `elm-ui` concepts)
* #elm-ui channel in [the Elm slack](https://elmlang.herokuapp.com/)