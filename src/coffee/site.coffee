

class Warper

  constructor: ->
    @attach_ux()

  const: ->
    OLDEST_DATE: new Date(1900,0,1)

  attach_ux: ->
    $('#btn-submit').on 'click',            => @click_submit()
    $('#btn-reset').on 'click',            => @click_reset()
    $('#salt').on       'change',           => @salt_change()
    $('#salt').on       'keyup',            => @salt_change()
    $('#checkbox-salt-confirm').on 'click', => @any_change()
    $('#passphrase').on 'change',           => @any_change()
    $('#passphrase').on 'keyup',            => @any_change()
    $('#public-address').on 'click',        -> $(@).select()
    $('#private-key').on    'click',        -> $(@).select()

  any_change: ->
    $('#private-key').val ''
    $('#public-address').val ''
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
    $(".progress-form").html JSON.stringify o


  click_reset: ->
    $('#btn-submit').attr('disabled', true).show().html 'Generate'
    $('#passphrase, #salt, #public-address, #private-key').val ''
    $('.output-form').hide()
    $('#checkbox-salt-confirm').attr 'checked', false
    $('.salt-confirm').hide()
    $('.salt-summary').html ''
    @any_change()

  click_submit: ->
    $('#btn-submit').attr('disabled', true).html 'Running...'
    $('#btn-reset').attr('disabled', true).html 'Running...'

    $('.progress-form').show()

    d = {}
    (d[k] = v for k,v of window.params)
    console.log d
    d.salt = new warpwallet.WordArray.from_utf8 $('#salt').val()
    d.key  = new warpwallet.WordArray.from_utf8 $('#passphrase').val()
    d.progress_hook = (o) => @progress_hook o

    warpwallet.scrypt d, (words) =>

      $('.output-form').show()
      $('.progress-form').hide()
      $('#btn-submit').hide()
      $('#btn-reset').attr('disabled', false).html 'Clear &amp; reset'
      out = warpwallet.generate words.to_buffer()
      $('#public-address').val out.public
      $('#private-key').val    out.private

$ ->
  new Warper()
