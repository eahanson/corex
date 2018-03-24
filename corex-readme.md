# Corex

## First-time setup
    
    bin/setup
    mix ecto.create 
    bin/cli doctor

## CLI
* Build & run: `bin/cli-build [command]`
* Run  : `bin/cli [command]` (try: `bin/cli help`)

## Deps
* Install : `mix deps.get`
* Outdated: `mix hex.outdated`

## Web server
* Run : `mix phx.server`
* View: `http://localhost:4000`

## Using Yarn
* [https://yarnpkg.com/en/docs/usage](https://yarnpkg.com/en/docs/usage)
* Add package: `cd assets` and `yarn add [package]`
* Add dev package: `cd assets` and `yarn add [package] --dev`

## Convert eex to slime
* Install (OS X): `brew install rbenv ruby-build` and `rbenv install` and `gem install eex2slime`
* Run: `eex2slime [input-file]`