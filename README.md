# RippleWarpWallet

A ripple brain wallet generator that uses scrypt.

## Install

Ripple uses npm to manage its dependencies. Run
```sh
$ npm install
```
to install the needed dependencies.

## Build

To build the site from source, we depend on iced-coffee-script. Install it by running
```sh
$ npm install -g iced-coffee-script
$ npm install -d
```
Then do
```sh
$ icake build
```
to build once, or
```sh
$ icake watch
```
to watch for changes and re-build during development.

## Github Pages

This repo is currently deployed using Github Pages for projects into the docs/ folder. The docs/ folder is not actually for docs. It is automatically updated at build time.