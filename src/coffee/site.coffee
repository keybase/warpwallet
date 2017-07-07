class Warper

  constructor: ->
    @check_compatibility()
    @attach_ux()
    if window.SALT_DEFAULT?
      $('#salt').val window.SALT_DEFAULT
      $('#salt').attr 'disabled', true
      $('.salt-label').text 'Prefilled salt'

  check_compatibility: ->
    if not Int32Array?
      $('.form-container').html '''
        <p>
          Sorry, but your browser is too old to run WarpWallet, which requires Int32Array support.
        </p>'''

  escape_user_content: (s) -> s.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/\"/g, '&quot;').replace(/\'/g, '&#39;')

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
    $('.what-salt').on      'click',        => $('.salt-explanation').toggle()

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
    else if salt?.length and not @salt_ok()
      err = "Fix your salt"
    else if salt?.length and (not chk) and (not window.SALT_DEFAULT?)
      err = "Confirm your salt"
    else if pp.length < 12
      warn = "Consider a larger passphrase"

    if err
      $('#btn-submit').attr('disabled', true).html err
    else if warn
      $('#btn-submit').attr('disabled', false).html warn
    else
      $('#btn-submit').attr('disabled', false).html "Generate"
    $('.output-form').hide()
    $('#public-address-qr').html ''
    $('#private-key-qr').html ''

  commas: (n) ->
    while (/(\d+)(\d{3})/.test(n.toString()))
      n = n.toString().replace /(\d+)(\d{3})/, '$1,$2'
    n

  salt_ok: ->
    salt = $('#salt').val()
    return (salt.match /^[\S]+@[\S]+\.[\S]+$/) or window.SALT_DEFAULT?

  salt_change: ->
    salt = $('#salt').val()
    $('#checkbox-salt-confirm').attr 'checked', false
    if not salt.length
      $('.salt-confirm').hide()
    if window.SALT_DEFAULT?
      $('.salt-confirm').hide()
    else if @salt_ok()
      $('.salt-confirm').show()
      $('.salt-summary').html @escape_user_content salt
    else
      $('.salt-confirm').hide()
    @any_change()

  progress_hook: (o) ->
    if o.what is 'scrypt'
      w = (o.i / o.total) * 50
      $('.progress-form .bar').css('width', "#{w}%")
      $('.progress-form .bar .progress-scrypt').html "scrypt #{@commas o.i} of #{@commas o.total}"

    else if o.what is 'pbkdf2'
      w = 50 + (o.i / o.total) * 50
      $('.progress-form .bar').css('width', "#{w}%")
      $('.progress-form .bar .progress-pbkdf2').html "&nbsp; pbkdf2 #{@commas o.i} of #{@commas o.total}"

  click_reset: ->
    $('#btn-submit').attr('disabled', false).show().html 'Please enter a passphrase'
    $('#passphrase, #public-address, #private-key').val ''
    if not window.SALT_DEFAULT?
      $('#salt').val ''
    $('#checkbox-salt-confirm').attr 'checked', false
    $('.salt-summary').html ''
    $('.salt-confirm').hide()
    $('.progress-form').hide()
    $('.output-form').hide()
    $('#public-address-qr').html ''
    $('#private-key-qr').html ''

  write_qrs: (pub, priv) ->
    params =
      width:        256
      height:       256
      colorLight:   "#f8f8f4"
      correctLevel: QRCode.CorrectLevel.H
    (new QRCode "public-address-qr", params).makeCode pub
    (new QRCode "private-key-qr", params).makeCode priv

  click_submit: ->
    $('#btn-submit').attr('disabled', true).html 'Running...'
    $('#btn-reset').attr('disabled', true).html 'Running...'
    $('#passphrase, #salt, checkbox-salt-confirm').attr 'disabled', true
    $('.progress-pbkdf2, .progress-scrypt').html ''
    $('.progress-form').show()

    warpwallet.run {
      passphrase : $('#passphrase').val()
      salt : $('#salt').val()
      progress_hook : (o) => @progress_hook o
      params : window.params
    }, (res) =>

      $('#passphrase, #checkbox-salt-confirm').attr 'disabled', false
      if not window.SALT_DEFAULT?
        $('#salt').attr 'disabled', false
      $('.progress-form').hide()
      $('.output-form').show()
      $('#btn-submit').hide()
      $('#btn-reset').attr('disabled', false).html 'Clear &amp; reset'
      $('#public-address').val res.address
      $('#private-key').val res.secret
      @write_qrs res.address, res.secret
      return

$ ->
  new Warper()
