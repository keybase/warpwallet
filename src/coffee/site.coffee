

class Warper

  constructor: ->
    @attach_ux()

  attach_ux: ->
    $('#btn-submit').on 'click',            => @click_submit()
    $('#btn-reset').on 'click',             => @click_reset()
    $('#salt').on       'change',           => @salt_change()
    $('#salt').on       'keyup',            => @salt_change()
    $('#checkbox-salt-confirm').on 'click', => @any_change()
    $('#passphrase').on 'change',           => @any_change()
    $('#passphrase').on 'keyup',            => @any_change()
    $('#public-address').on 'click',        -> $(@).select()
    $('#private-key').on    'click',        -> $(@).select()

  any_change: ->
    $('.progress-form').hide()
    $('#private-key').val ''
    $('#public-address').val ''
    $('#btn-submit').attr('disabled', false).show().html 'Generate'
    pp   = $('#passphrase').val()
    salt = $('#salt').val()
    chk  = $('#checkbox-salt-confirm').is ":checked"    
    err  = null
    warn = null
    if not pp.length
      err = "Please enter a passphrase"
    else if salt?.length and not chk
      err = "Fix and accept your salt"
    else if pp.length < 12
      warn = "Consider a larger passphrase"

    if err
      $('#btn-submit').attr('disabled', true).html err
    else if warn
      $('#btn-submit').attr('disabled', false).html warn
    else  
      $('#btn-submit').attr('disabled', false).html "Generate"
    $('.output-form').hide()
    $('#public-address').val ''
    $('#private-key').val ''

  commas: (n) ->
    while (/(\d+)(\d{3})/.test(n.toString()))
      n = n.toString().replace /(\d+)(\d{3})/, '$1,$2'
    n

  salt_change: ->
    salt = $('#salt').val()
    $('#checkbox-salt-confirm').attr 'checked', false
    if not salt.length
      $('.salt-confirm').hide()
    if salt.match /// ^[0-9]{4}-[0-9]{2}-[0-9]{2} $///
      mom = moment salt, "YYYY-MM-DD"
      $('.salt-confirm').show()
      $('.salt-summary').html mom.format "MMMM Do, YYYY"
    else
      $('.salt-confirm').hide()
    @any_change()

  progress_hook: (o) ->
    if o.what is 'scrypt'
      w = (o.i / o.total) * 50
      $('.progress-form .bar').css('width', "#{w}%").html "scrypt #{@commas o.i} of #{@commas o.total}"

    else if o.what is 'pbkdf2 (pass 2)'
      w = 50 + (o.i / o.total) * 50
      $('.progress-form .bar').css('width', "#{w}%").html "pbkdf2 #{@commas o.i} of #{@commas o.total}"

  click_reset: ->
    $('#btn-submit').attr('disabled', false).show().html 'Generate'
    $('#passphrase, #salt, #public-address, #private-key').val ''
    $('#checkbox-salt-confirm').attr 'checked', false
    $('.salt-summary').html ''
    $('.salt-confirm').hide()
    $('.progress-form').hide()
    $('.output-form').hide()

  click_submit: ->
    $('#btn-submit').attr('disabled', true).html 'Running...'
    $('#btn-reset').attr('disabled', true).html 'Running...'
    $('#passphrase, #salt, checkbox-salt-confirm').attr 'disabled', true
    $('.progress-form').show()

    d = {}
    (d[k] = v for k,v of window.params)
    d.salt = new warpwallet.WordArray.from_utf8 $('#salt').val()
    d.key  = new warpwallet.WordArray.from_utf8 $('#passphrase').val()
    d.progress_hook = (o) => @progress_hook o

    $('.progress-form').show()
    $('.progress-form .bar').html ''

    warpwallet.scrypt d, (words) =>

      $('#passphrase, #salt, checkbox-salt-confirm').attr 'disabled', false

      $('.output-form').show()
      $('#btn-submit').hide()
      $('#btn-reset').attr('disabled', false).html 'Clear &amp; reset'
      out = warpwallet.generate words.to_buffer()
      $('#public-address').val out.public
      $('#private-key').val    out.private

$ ->
  new Warper()
