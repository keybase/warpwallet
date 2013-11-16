fs          = require 'fs'
path        = require 'path'
coff        = require 'iced-coffee-script'
browserify  = require 'browserify'
exec        = require('child_process').exec
{version}   = require('./package.json')
crypto      = require('crypto')

# -----------------------------------------------------------
#
# Build with "icake build" which requires iced-coffee-script.
#
# Or use "icake watch" to put cake into a recompile loop
# while actively developing
# -----------------------------------------------------------

hash_file = (fn, cb) ->
  fd = fs.ReadStream fn
  hasher = crypto.createHash('SHA256')
  fd.on 'data', (d) ->
    hasher.update d
  await fd.on 'end', defer()
  ret = hasher.digest('hex')
  cb ret

hash_data = (data) ->
  hasher = crypto.createHash('SHA256')
  hasher.update data
  hasher.digest('hex')

build = (cb) ->
  latest = "./warp.io_latest.html"    
  await do_browserify defer()
  await fs.readFile "./warp.io_src.html", {encoding: "utf8"}, defer err, html
  await token_build_and_drop html, defer html
  await fs.readFile latest, {encoding: "utf8"}, defer err, old_html
  if err? or (old_html isnt html)
    console.log "Writing #{html.length} chars." + if old_html? then "(Changed from #{old_html.length} chars" else ""
    sha256 = hash_data html
    fullname = "./warp.io_#{version}_SHA256_#{sha256}.html"       
    await fs.writeFile fullname, html, {encoding: "utf8"}, defer err
    throw err if err?
    await fs.symlink fullname, latest, defer err
    throw err if err?
    # delete any old copies of this version
    await clean_old_ones sha256, defer err
    throw err if err?
    await exec "rm -rf ./warp.io_#{version}_SHA256_*.html", defer error, stdout, stdin    
  cb() if typeof cb is 'function'

task 'build', "build the html file", build

task 'watch', "build repeatedly", (cb) ->  
  while true
    await build defer()
    await setTimeout defer(), 500

compile_token = (p, cb) ->
  switch path.extname p
    when '.js', '.json'
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

do_browserify = (cb) ->
  b = browserify()
  b.add("./src/browserify/top.js")
  await b.bundle { standalone : 'warpwallet' }, defer err, res
  throw err if err?
  await fs.writeFile "./src/js/deps.js", res, { encoding : "utf8" }, defer err
  throw err if err?
  cb() 
