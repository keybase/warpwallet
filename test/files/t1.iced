
{scrypt,WordArray} = require 'triplesec'
{generate} = require 'keybase-bitcoin'
params = require '../../src/json/params.json'
spec = require '../spec.json'

run1 = (T, i, vec, cb) ->
  d = {}
  (d[k] = v for k,v of params)
  d.key = WordArray.from_utf8 vec.passphrase
  d.salt = WordArray.from_utf8 vec.salt
  await scrypt d, defer res
  seed = res.to_buffer()
  T.equal seed.toString('hex'), vec.seed, "v#{i}: seed matches"
  out = generate seed
  T.equal out.private, vec.keys.private, "v#{i}: private key matches"
  T.equal out.public, vec.keys.public, "v#{i}: public key matches"
  cb()

exports.test_spec = (T, cb) ->
  for v,i in spec.vectors
    await run1 T, i, v, defer()
    T.waypoint "Spec vector #{i}"
  cb()
