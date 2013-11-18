
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
  T.equal ret.seeds[0].toString('hex'), vec.seeds[0], "v#{i}: seeds[0] matches"
  T.equal ret.seeds[1].toString('hex'), vec.seeds[1], "v#{i}: seeds[1] matches"
  T.equal ret.private, vec.keys.private, "v#{i}: private key matches"
  T.equal ret.public, vec.keys.public, "v#{i}: public key matches"
  cb()

exports.test_spec = (T, cb) ->
  for v,i in spec.vectors
    await run1 T, i, v, defer()
    T.waypoint "Spec vector #{i}"
    await setTimeout defer(), 10
  cb()
