$ ->

  params = 
    N     : (1 << 17)
    c1    : (1 << 16)
    p     : 1
    r     : 8
    dkLen : 256/8

  progress_hook = (o) ->
    $("#progress").html JSON.stringify o

  $('#btn-submit').on 'click', ->
    $('.output-form').show()

    d = {}
    (d[k] = v for k,v of params)
    d.salt = $('#salt').val()
    d.key  = $('#passphrase').val()
    d.progress_hook = progress_hook

    warpwallet.scrypt d, (words) ->
      out = warpwallet.generate words.to_buffer()
      $('#public-address').val out.public
      $('#private-key').val    out.private
