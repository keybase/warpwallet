
{scrypt,pbkdf2,HMAC_SHA256,WordArray} = require 'triplesec'
generate = require('keybase-bitcoin').generate
params = require('../json/params.json')

exports.run = run = ({passphrase, salt, progress_hook}, cb) ->

  d = {}
  seeds = []

  (d[k] = v for k,v of params)
  d.dkLen *= 2
  d.key = WordArray.from_utf8 passphrase
  d.salt = WordArray.from_utf8 salt
  d.progress_hook = progress_hook
  await scrypt d, defer s0

  [s1,s2] = s0.split 2
  seeds.push s0.to_buffer()

  d2 = {
    key : s2
    salt : d.salt
    c : params.pbkdf2c
    dkLen : params.dkLen
    progress_hook : progress_hook
    klass : HMAC_SHA256
  }
  await pbkdf2 d2, defer s3
  seeds.push s3.to_buffer()
  s1.xor s3, {}
  seed_final = s1.to_buffer()
  seeds.push seed_final

  for obj in [ s0,s1,s2,s3,d.key ]
    obj.scrub()

  out = generate seed_final
  out.seeds = seeds
  cb out

