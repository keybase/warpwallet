
{tail} = require '../../'
{join} = require 'path'

file = join(__dirname , "taildata.txt")
last_20 = "sable\nadvisableness\n"
exports.tail_partial = (T,cb) ->
  await tail file, 1000, defer err, buf
  T.no_error err
  T.equal last_20, buf[-20...].toString(), "got last 20"
  cb null

exports.tail_full = (T, cb) ->
  await tail file, 100000, defer err, buf
  T.no_error err
  T.equal last_20, buf[-20...].toString(), "got last 20"
  cb null

