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


# Using Corex As A Template For A New Elixir/Phoenix App

## Create the project

Create a new project, and set the Corex repo as a remote:

    mkdir your-new-project
    cd your-new-project
    git init
    git remote add corex git@github.com:eahanson/corex
    git fetch corex
    git reset --hard corex/master
    # create project-name on github
    git remote add origin git@github.com:[organization/project-name]
    git push -u origin master
    
You can keep `corex` as a remote to pull new changes from `corex` into your project.
    
## Importing changes from Corex

See what's changed: 
    
    git fetch corex
    git log corex/master
    
Merge all changes from the Corex:

    git merge corex/master
        