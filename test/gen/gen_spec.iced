
input = require './input.json'
{Child} = require('iced-utils').spawn
scrypt = process.argv[2]
bu = process.argv[3]
params = require '../../src/json/params.json'
pkg = require '../../package.json'
input = require './input.json'


class Runner
  constructor : ({@scrypt, @bu}) ->

  make_vectors : (cb) ->
    out = []
    for v,i in input[0...1]
      await @make_vector v, defer out[i]
    cb out

  run : (cb) ->
    out = { 
      generated : (new Date).toString()
      version : pkg.version
      params
    }
    await @make_vectors defer out.vectors
    cb out

  run_scrypt : (input, cb) ->
    args = [
      "-N", params.N,
      "-p", params.p,
      "-r", params.r,
      "-d", params.dkLen,
      "-c", params.c1,
      "-P", input.passphrase,
      "-s", input.salt
    ]
    opts = { 
      quiet : true 
      interp : @scrypt
    }
    child = new Child args, opts
    out = []
    child.filter (l, which) -> out.push l
    await child.run().wait defer status
    x = /result: ([0-9a-f]+)/
    ret = if (m = out[0].match x)? then m[1] else null
    cb ret

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
await r.run defer out
console.log JSON.stringify out, null, 4

