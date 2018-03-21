# Corex

## First-time setup
`bin/setup`
`mix ecto.create` 
`bin/cli doctor`

## CLI
Build: `bin/cli-build [command]`
Run  : `bin/cli [command]`

## Deps
Install : `mix deps.get`
Outdated: `mix hex.outdated`

## Web server
Run : `mix phx.server`
View: `http://localhost:4000`

## Using Yarn
[https://yarnpkg.com/en/docs/usage](https://yarnpkg.com/en/docs/usage)
Add package: `cd assets` and `yarn add [package]`
Add dev package: `cd assets` and `yarn add [package] --dev`

## Convert eex to slime
Install: `brew install rbenv ruby-build` and `rbenv install` and `gem install eex2slime`
Run: `eex2slime [input-file]`