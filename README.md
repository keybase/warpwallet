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