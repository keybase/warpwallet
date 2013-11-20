# warpwallet

A brain wallet generator that uses scrypt.

## Install

There's no npm module for WarpWallet since it's intended as a browser-only service.  However,
it does use npm to manage its dependencies

## Build

```sh
$ npm install -g iced-coffee-script
$ npm install -d
$ icake build
```

## Test

```sh
$ make test
```

## Regeneration of Test Vectors (which otherwise are fixed)

To generate our reference test vectors, we use the reference Scrypt implementation (in C), a 
Python PBKDF2, and a Python library to turn a seed into a keypair.  To see how this works, try:

```sh
$ cd test/gen && make build && make spec
```

## Why a Makefile and a Cakefile?

Internal disagreement as to which is better.





