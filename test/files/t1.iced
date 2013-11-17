
{scrypt,WordArray} = require 'triplesec'
{generate} = require 'keybase-bitcoin'
params = require '../src/json/params'

exports.run = run = ({passphrase, salt}, cb) ->
  d = {}
  (d[k] = v for k,v of params)
  d.key = WordArray.from_utf8 passphrase
  d.salt = WordArray.from_utf8 salt
  await scrypt d, defer res
  seed = res.to_buffer()
  out = generate seed
  out.seed = seed.toString('hex')
  cb out
