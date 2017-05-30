
fs = require 'fs'
{chain,make_esc} = require 'iced-error'

#-------------------

module.exports = tail = (fn, bytes, cb) ->
  fd = -1

  cb = chain cb, (lcb) ->
    if fd >= 0
      await fs.close fd, defer err
    lcb()
  esc = make_esc cb, "tail"

  await fs.open fn, "r", esc defer fd
  await fs.fstat fd, esc defer stat
  sz = stat.size
  offset = sz - bytes
  if offset < 0
    bytes = sz
    offset = 0
  buf = new Buffer bytes
  await fs.read fd, buf, 0, bytes, offset, esc defer()

  cb null, buf

#-------------------

