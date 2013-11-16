
input = require './input.json'
{spawn} = require('iced-utils').spawn
scrypt = process.argv[2]
bu = process.argv[3]
params = require '../../src/json/params.json'
pkg = require '../../package.json'

class Runner
  constructor : ({@scrypt, @bu}) ->

  make_vectors : (input, cb) ->
    out = []
    for v,i in input
      await @make_vector v, defer out[i]
    cb out

  run : (input, cb) ->
    out = { 
      generated : (new Date).toString()
      version : pkg.version
      params
    }
    await @make_vectors input, defer out.vectors
    cb out

  run_scrypt : (input, cb) ->
    cb "aaa"

  run_bu : (seed, cb) ->
    cb {
      "private"  : 1,
      "public" : 2
    }

  make_vector : (input, cb) ->
    await @run_scrypt input, defer seed
    await @run_bu seed, defer keys
    out = {}
    (out[k] = v for k,v of input)
    out.seed = seed
    out.keys = keys
    cb out

r = new Runner { scrypt, bu }
await r.run [{dog : 1}] , defer out
console.log JSON.stringify out, null, 4

