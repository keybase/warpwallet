
data = require '../data/t1.json'
{generate} = require '../../index'
{Crypto} = require '../../lib/lib'

sha256 = (x) -> (new Buffer Crypto.SHA256(x), 'hex')

exports.t1 = (T,cb) ->
  for v in data.vectors
    obj = generate sha256 v.input
    T.equal obj.private, v.private, "private parts #{v.id}"
    T.equal obj.public, v.public, "public parts #{v.id}"
  cb()
