# WarpWallet

A brain wallet generator that uses [scrypt](https://en.wikipedia.org/wiki/Scrypt) and
[pbkdf2](https://en.wikipedia.org/wiki/PBKDF2) for key stretching.


## Install

There's no npm module for WarpWallet since it's intended as a browser-only service.  However,
it does use npm to manage its dependencies.

## Build

```sh
$ sudo ln -s /usr/bin/nodejs /usr/bin/node
$ sudo npm install -g iced-coffee-script
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
$ pip install virtualenv
$ sudo /usr/bin/easy_install virtualenv
$ cd test/gen && make build && make spec
```

## Why a Makefile and a Cakefile?

Internal disagreement as to which is better.





