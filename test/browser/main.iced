
mods =  
  t1 : require '../files/t1.iced'

{BrowserRunner} = require('iced-test')

window.onload = () ->
  br = new BrowserRunner { log : "log", rc : "rc" }
  await br.run mods, defer rc
