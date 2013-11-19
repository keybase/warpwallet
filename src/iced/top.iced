
{scrypt,pbkdf2,HMAC_SHA256,WordArray,util} = require 'triplesec'
generate = require('keybase-bitcoin').generate
params = require('../json/params.json')

#=====================================

from_utf8 = (s, i) ->
  b = new Buffer s, 'utf8'
  b2 = Buffer.concat [ b, (new Buffer [ i ]) ]
  ret = WordArray.from_buffer b2
  util.scrub_buffer(b)
  util.scrub_buffer(b2)
  return ret

#=====================================

exports.run = run = ({passphrase, salt, progress_hook}, cb) ->

  d = {}
  seeds = []

  (d[k] = v for k,v of params)
  d.key = from_utf8(passphrase, 1)
  d.salt = from_utf8(salt, 1)
  d.progress_hook = progress_hook
  await scrypt d, defer s1

  seeds.push s1.to_buffer()

  d2 = {
    key : from_utf8(passphrase, 2)
    salt : from_utf8(salt, 2)
    c : params.pbkdf2c
    dkLen : params.dkLen
    progress_hook : progress_hook
    klass : HMAC_SHA256
  }
  await pbkdf2 d2, defer s2
  seeds.push s2.to_buffer()
  s1.xor s2, {}
  seed_final = s1.to_buffer()
  seeds.push seed_final

  for obj in [ s1,s2, d.key, d2.key]
    obj.scrub()

  out = generate seed_final
  out.seeds = seeds
  cb out

#=====================================

