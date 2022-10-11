#! /usr/bin/bash

set -o xtrace

mkdir bin
git submodule update --init --recursive
export PATH="/opt/build/repo/bin:$PATH"
curl https://static.lamdera.com/bin/linux/lamdera -o bin/lamdera
chmod a+x bin/lamdera
lamdera --version
npm i
npx elm-tooling install
(cd elm-pages && npm i && npm run build:generator)
export ELM_HOME="$NETLIFY_BUILD_BASE/cache/elm"
npm run build
