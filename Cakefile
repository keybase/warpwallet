fs          = require 'fs'
path        = require 'path'
coff        = require 'iced-coffee-script'
browserify  = require 'browserify'
exec        = require('child_process').exec
{version}   = require('./package.json')
crypto      = require('crypto')
{make_esc}  = require 'iced-error'
{brew}      = require 'brew'

# -----------------------------------------------------------
#
# Build with "icake build" which requires iced-coffee-script.
#
# This file is somewhat large because it does a bunch of cool
# things to build the final HTML file, such as converting
# png's to HTML data, etc.
#
# Or use "icake watch" to put cake into a recompile loop
# while actively developing
# -----------------------------------------------------------

build = (cb) ->
  esc = make_esc cb, "build"
  latest = "./web/warp_latest.html"    
  await do_browserify defer()
  await fs.readFile "./warp_src.html", {encoding: "utf8"}, esc defer html
  await token_build_and_drop html, defer html
  html = html.replace 'sourceMappingURL', 'sourceMappingDisabled'
  await fs.readFile latest, {encoding: "utf8"}, defer err, old_html
  if err? or (old_html isnt html)
    # Clean out the old symlink
    await fs.unlink latest, esc defer() unless err?
    console.log "Writing #{html.length} chars." + if old_html? then " (Changed from #{old_html.length} chars)" else ""
    sha256 = hash_data html
    fullname = "warp_#{version}_SHA256_#{sha256}.html"       
    await fs.writeFile "./web/#{fullname}", html, {encoding: "utf8"}, esc defer()
    await fs.symlink fullname, latest, esc defer()
    # delete any old copies of this version
    await clean_old_ones sha256, esc defer()
  cb null

task 'build', "build the html file", (cb) ->
  await build defer err
  throw err if err?
  cb?()

task 'watch', "build repeatedly", (cb) ->  
  await build defer err
  ready = false
  b = new brew {
    match:    /^.*$/
    includes: ['./src/', './warp_src.html']
    compile:  (path, txt, cb)  -> cb null, txt 
    join:     (strs, cb)       -> cb null, (strs.join "\n") 
    compress: (str,  cb)    -> cb null, str
    onChange: ->
      while not b.isReady()
        await setTimeout defer(), 500
        console.log "waiting for build"
      await build defer err
  }
  while true
    await setTimeout defer(), 1000

hash_data = (data) ->
  hasher = crypto.createHash('SHA256')
  hasher.update(data, 'utf8')
  hasher.digest('hex')

clean_old_ones = (new_one, cb) ->
  await fs.readdir "./web", defer err, files
  rxx = "warp_#{version}_SHA256_([a-f0-9]+)\.html"
  for file in files 
    if ((m = file.match rxx)? and (m[1] isnt new_one))
      await fs.unlink "./web/#{file}", defer err
  cb()

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
  b = browserify { standalone : 'warpwallet' }
  b.transform(require 'icsify')
  b.add("./src/iced/top.iced")
  await b.bundle defer err, res
  throw err if err?
  await fs.writeFile "./src/js/deps.js", res, { encoding : "utf8" }, defer err
  throw err if err?
  cb() 
