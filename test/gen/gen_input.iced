
{prng} = require 'crypto'

specs = [
  { password : 8,  salt : 8 , num : 4 },
  { password : 16, salt : 16, num : 4 },
  { password : 24, salt : 16, num : 4 }
]

gen_randos = (n) ->
  prng(n).toString('base64').replace(///=+$///, '')

out = []
for spec in specs 
  for i in [0...spec.num]
    out.push {
      passphrase : gen_randos(spec.password)
      salt       : gen_randos(spec.salt)
    }
console.log JSON.stringify out, null, 4