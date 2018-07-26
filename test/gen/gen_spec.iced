
input = require './input.json'
{Child} = require('iced-utils').spawn
scrypt = process.argv[2]
pbkdf2 = process.argv[3]
bu = process.argv[4]
mnemonic = process.argv[5]
params = require '../../src/json/params.json'
pkg = require '../../package.json'
input = require './input.json'
colors = require 'colors'

CHECK = "\u2714"

##=====================================================================

hexlify = (s) -> (new Buffer s).toString('hex')

##=====================================================================

class Runner

  #-------------------

  constructor : ({@input, @scrypt, @pbkdf2, @bu, @mnemonic, @params}) ->

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
      @params
    }
    await @make_vectors defer out.vectors
    cb out

  #-------------------

  run_scrypt : (input, cb) ->
    args = [
      "-N", @params.N,
      "-p", @params.p,
      "-r", @params.r,
      "-d", @params.dkLen,
      "-P", (input.passphrase + "\x01"),
      "-s", (input.salt + "\x01")
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

  run_pbkdf2 : (input, s1, cb) ->
    args = [
      "-c", @params.pbkdf2c,
      "-d", @params.dkLen,
      "-k", (hexlify(input.passphrase) + "02"),
      "-s", (hexlify(input.salt) + "02"),
      "-b", s1
    ]
    opts = { 
      quiet : true 
      interp : @pbkdf2
    }
    child = new Child args, opts
    out = []
    child.filter (l, which) -> out.push l
    await child.run().wait defer status
    [s2, s3] = out.join('\n').split /\n/
    cb s2, s3

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
        bu_out[last_key][key.replace(/^\s+|\s+$/g, '')] = val
      else
        last_key = key.replace(/\s+$/, '')
        bu_out[last_key] = { "value" : val}

    cb {
      "private"  : bu_out.wif.uncompressed
      "public" : bu_out['Bitcoin address uncompressed'].value
    }

  #-------------------

  run_mnemonic : (seed, cb) ->
    args = [ seed ]
    opts = {
      quiet : true
      interp : @mnemonic
    }
    child = new Child args, opts
    out = []
    child.filter (l, which) -> out.push l
    await child.run().wait defer status
    cb out.join("\n").replace(/\s+$/, '')

  #-------------------

  make_vector : (input, cb) ->
    await @run_scrypt input, defer s1
    await @run_pbkdf2 input, s1, defer s2, s3
    await @run_bu s3, defer keys
    await @run_mnemonic s3, defer wordlist
    out = {}
    (out[k] = v for k,v of input)
    out.seeds = [ s1, s2, s3 ]
    out.keys = keys
    out.mnemonic = wordlist
    cb out

##=====================================================================

r = new Runner { input, scrypt, pbkdf2, bu, mnemonic, params }
await r.run defer out
console.log JSON.stringify out, null, 4

