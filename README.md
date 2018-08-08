# WarpWallet

A brain wallet generator that uses [scrypt](https://en.wikipedia.org/wiki/Scrypt) and
[pbkdf2](https://en.wikipedia.org/wiki/PBKDF2) for key stretching.


## Install

There's no npm module for WarpWallet since it's intended as a browser-only service.  However,
it does use npm to manage its dependencies.

## Build

```sh
$ sudo npm install -g iced-coffee-script
$ npm install -d
$ npm install bitcore-mnemonic
$ icake build
```

IcedCoffeeScript uses Node.js for the build. There is a naming conflict with the node package
(Amateur Packet Radio Node Program), and the nodejs binary has been renamed from `node` to `nodejs`.
You may need to symlink `/usr/bin/node` to `/usr/bin/nodejs` to get things work.
Use: `sudo ln -s /usr/bin/nodejs /usr/bin/node`

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





