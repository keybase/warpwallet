
{scrypt,pbkdf2,HMAC_SHA256,WordArray} = require 'triplesec'
generate = require('keybase-bitcoin').generate

exports.run = run = ({passphrase, salt, params, progress_hook}, cb) ->

  d = {}
  (d[k] = v for v of params)
  d.key = WordArray.from_utf8 passphrase
  d.salt = WordArray.from_utf8 salt
  d.progress_hook = progress_hook
  await scrypt d, defer w

  d2 = {
    key : scrypt_words
    salt : d.salt
    c : params.pbkdf2c
    dkLen : d.dkLen
    progress_hook : progress_hook
    klass : HMAC_SHA256
  }
  await pbkdf2 d2, defer w2

  w.xor x2, {}
  
  out.seed = w.to_buffer()
  out = generate out.seed
  cb out
