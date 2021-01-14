---
type: episode
number: 22
title: elm-tooling with Simon Lydell
description: elm-tooling helps you manage versions of tools like elm-format and elm. It downloads them more efficiently and securely. We discuss with the author, Simon Lydell.
simplecastId: a3b97a42-24a0-4da0-b728-581872ab9971
---

- Simon Lydell ([twitter](https://twitter.com/SimonLydell)) ([github](https://github.com/lydell/))
- [`elm-tooling-cli`](https://github.com/elm-tooling/elm-tooling-cli)
- [`elm-json`](https://github.com/zwilias/elm-json)
- Install elm-tooling into your npm dev dependencies
- [`npx`](https://www.npmjs.com/package/npx)
- [`elm-publish-action`](https://github.com/dillonkearns/elm-publish-action)
- NPM's [package.json `scripts` section](https://docs.npmjs.com/cli/v7/using-npm/scripts)
- NPM `postinstall` scripts
- Richard's [recommendation to use `npm config set ignore-scripts true`](https://twitter.com/rtfeldman/status/1070755222077620224), which can cause issues because it also skips the `postinstall` from your `package.json`
- [`elm-tooling-cli` docs website](https://elm-tooling.github.io/elm-tooling-cli/)

## Elm tooling in ci

- [GitHub Actions](https://docs.github.com/en/free-pro-team@latest/actions)
- Simon's [example GitHub Actions workflow](https://github.com/elm-tooling/elm-tooling-cli/blob/main/.github/workflows/example.yml) with `elm-tooling`
- Separate steps for Elm tooling install and npm install to optimize caching
- `npm run --silent` (or `-s`) to reduce noise (more ways to do it [in this StackOverflow answer](https://stackoverflow.com/a/34426599))
- `npm test` and `npm start` to run `start` and `test` from your `package.json` scripts
- [`elm-tooling` quick start page](https://elm-tooling.github.io/elm-tooling-cli/getting-started.html#quick-start)
