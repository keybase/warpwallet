
f = (n, cb) ->
  await setTimeout defer(), 100
  cb 111 * n

module.exports = (n) ->
  await f n, defer m
  console.log m
