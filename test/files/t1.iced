
{scrypt,WordArray} = require 'triplesec'
{generate} = require 'keybase-bitcoin'
params = require '../../src/json/params.json'
spec = require '../spec.json'
{run} = require '../../src/iced/top.iced'

run1 = (T, i, vec, cb) ->
  await run { 
    passphrase : vec.passphrase
    salt : vec.salt
    params
  }, defer ret
  for s,j in ret.seeds
    T.equal s.toString('hex'), vec.seeds[j], "v#{i}: seeds[#{j}] matches"
  T.equal ret.private, vec.keys.private, "v#{i}: private key matches"
  T.equal ret.public, vec.keys.public, "v#{i}: public key matches"
  cb()

exports.test_spec = (T, cb) ->
  for v,i in spec.vectors
    await run1 T, i, v, defer()
    T.waypoint "Spec vector #{i}"
    await setTimeout defer(), 10
  cb()
