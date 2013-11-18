
{scrypt,pbkdf2,HMAC_SHA256,WordArray} = require 'triplesec'
generate = require('keybase-bitcoin').generate

exports.run = run = ({passphrase, salt, params, progress_hook}, cb) ->

  d = {}
  (d[k] = v for k,v of params)
  d.key = WordArray.from_utf8 passphrase
  d.salt = WordArray.from_utf8 salt
  d.progress_hook = progress_hook
  await scrypt d, defer w

  seed1 = w.to_buffer()

  d2 = {
    key : w.clone()
    salt : d.salt
    c : params.pbkdf2c
    dkLen : d.dkLen
    progress_hook : progress_hook
    klass : HMAC_SHA256
  }
  await pbkdf2 d2, defer w2

  w.xor w2, {}
  seed2 = w.to_buffer()

  w.scrub()
  w2.scrub()
  d.key.scrub()

  out = generate seed2
  out.seeds = [ seed1, seed2 ]
  cb out
