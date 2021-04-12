---
type: episode
number: 28
title: GitHub Actions
description: We discuss best practices to setup GitHub Actions to make sure everyone has the same source of truth for checking your Elm code and deploying to production.
simplecastId: 6d9e098b-51b3-4c95-8fd0-dd36005e3fce
---

- [Continuous Integration](https://www.martinfowler.com/articles/continuousIntegration.html) (CI)
- CD ([Continuous Delivery](https://martinfowler.com/bliki/ContinuousDelivery.html), [Continuous Deployment](https://en.wikipedia.org/wiki/Continuous_deployment))
- [Mob programming](https://en.wikipedia.org/wiki/Mob_programming)
- [`elm-program-test` episode](https://elm-radio.com/episode/elm-program-test)
- [Cypress testing framework](https://www.cypress.io/)
- [GH actions `on` events](https://docs.github.com/en/actions/reference/workflow-syntax-for-github-actions#on) (`schedule`, `workflow_dispatch`, `pull_request`, etc.)
- `elm-review new-package`
- [npm-run-all](https://www.npmjs.com/package/npm-run-all)
- Can run `npm-run-all test:*`, but don't know the order it will run in
- git hooks
- [Dependabot](https://dependabot.com/)
- Dillon's [blog post about using dependabot for Elm dependencies](https://dev.to/dillonkearns/keeping-elm-dependencies-current-2b25)
- [Send a tweet with a GH action](https://github.com/gr2m/twitter-together)
- [Dillon's GH profile](https://github.com/dillonkearns/dillonkearns) (and [the GH action workflow for it](https://github.com/dillonkearns/dillonkearns/blob/main/.github/workflows/update-weekly-tips.yml))
- [GH Action to include blog posts in profile feed](https://github.com/gautamkrishnar/blog-post-workflow)
- [GitHub's Octokit API](https://octokit.github.io/rest.js/v18)
- [Core GitHub Actions JavaScript packages](https://github.com/actions/toolkit)
- [JavaScript GitHub Actions starter template](https://github.com/actions/javascript-action)
- [Unix toolchain philosophy](https://en.wikipedia.org/wiki/Unix_philosophy)
- [elm-tooling-action](https://github.com/mpizenberg/elm-tooling-action)
- Simon Lydell's [example GitHub Actions workflow](https://elm-tooling.github.io/elm-tooling-cli/ci/)
- [GitHub Actions cache api](https://github.com/actions/cache)
- [Brian Douglas' dev.to blog post series](https://dev.to/bdougieyo/series/11453)
- [Edward Thomson's GitHub Actions advent calendar](https://www.edwardthomson.com/blog/github_actions_advent_calendar.html)
