
input = require './input.json'
{Child} = require('iced-utils').spawn
scrypt = process.argv[2]
bu = process.argv[3]
params = require '../../src/json/params.json'
pkg = require '../../package.json'
input = require './input.json'
colors = require 'colors'

CHECK = "\u2714"

##=====================================================================

class Runner

  #-------------------

  constructor : ({@input, @scrypt, @bu}) ->

  #-------------------

  make_vectors : (cb) ->
    out = []
    for v,i in @input
      await @make_vector v, defer out[i]
      console.error "#{CHECK} Done with vector #{i+1} of #{@input.length}".green
    cb out

  #-------------------

  run : (cb) ->
    out = { 
      generated : (new Date).toString()
      version : pkg.version
      params
    }
    await @make_vectors defer out.vectors
    cb out

  #-------------------

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

  #-------------------

  run_bu : (seed, cb) ->
    args = [ seed ] 
    opts = { 
      quiet : true 
      interp : @bu
    }
    child = new Child args, opts
    out = []
    child.filter (l, which) -> out.push l
    await child.run().wait defer status

    bu_out = {}
    primary_key = null
    for line in out.join("\n").split(/\n+/) when line.length
      [key,val] = line.split(/:\s+/)
      if key[0] is ' '
        bu_out[last_key][key.replace(/\s+/, '')] = val
      else
        last_key = key
        bu_out[key] = { _ : val}

    cb {
      "private"  : bu_out.WIF.uncompressed
      "public" : bu_out['Bitcoin address'].uncompressed
    }

  #-------------------

  make_vector : (input, cb) ->
    await @run_scrypt input, defer seed
    await @run_bu seed, defer keys
    out = {}
    (out[k] = v for k,v of input)
    out.seed = seed
    out.keys = keys
    cb out

##=====================================================================

r = new Runner { input, scrypt, bu }
await r.run defer out
console.log JSON.stringify out, null, 4

