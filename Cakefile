fs   = require 'fs'
path = require 'path'
coff = require 'iced-coffee-script'
browserify = require 'browserify'

#
# Build with "icake build" which requires iced-coffee-script.
#

compile_token = (p, cb) ->
  switch path.extname p
    when '.js'
      await fs.readFile p, {encoding: "utf8"}, defer err, res
    when '.css'
      await fs.readFile p, {encoding: "utf8"}, defer err, res
      await token_build_and_drop res, defer res # there may be png's in there
    when '.coffee'
      await fs.readFile p, {encoding: "utf8"}, defer err, res
      try
        res = coff.compile res
      catch e
        console.log "Couldn't compile #{p}. Coffee-script error. Exiting."
        process.exit 1
    when '.png'
      await fs.readFile p, defer err, res
      res = "data:image/png;base64," + res.toString 'base64'
    when '.jpg'
      await fs.readFile p, defer err, res
      res = "data:image/jpeg;base64," + res.toString 'base64'
  if not res?
    console.log "Couldn't compile #{p}. Exiting"
    process.exit 1
  cb res

token_build_and_drop = (html, cb) ->
  ###
    tokens are something like {::src/foo.js::}
  ###
  matches = html.match /// \{\:\:([0-9a-z_\-\.\/])+\:\:\} ///gi
  if matches?
    for str, i in matches
      await compile_token "./#{str[3...-3]}", defer replacement
      while (pos = html.indexOf str) isnt -1
        html = html[0...pos] + replacement + html[(pos+str.length)...]
  cb html

build = (cb) ->
  await do_browserify defer()
  await fs.readFile "./warp.io_src.html", {encoding: "utf8"}, defer err, html
  await token_build_and_drop html, defer html
  await fs.readFile "./warp.io.html", {encoding: "utf8"}, defer err, old_html
  if err? or (old_html isnt html)
    console.log "Writing #{html.length} chars." + if old_html? then "(Changed from #{old_html.length} chars" else ""
    await fs.writeFile "./warp.io.html", html, {encoding: "utf8"}, defer err
  cb() if typeof cb is 'function'

do_browserify = (cb) ->
  b = browserify()
  b.add("./src/browserify/top.js")
  await b.bundle { standalone : 'warpwallet' }, defer err, res
  throw err if err?
  await fs.writeFile "./src/js/deps.js", res, { encoding : "utf8" }, defer err
  throw err if err?
  cb() 

task 'build', "build the html file", build

task 'watch', "build repeatedly", (cb) ->  
  while true
    await build defer()
    await setTimeout defer(), 500
