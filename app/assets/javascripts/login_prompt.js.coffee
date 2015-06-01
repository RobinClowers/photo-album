$(document).on 'ajax:error', (event, xhr, status, error) ->
  if xhr.status == 401
    window.photoOverlay.close()
    window.overlay = new Overlay('.js-login-prompt')
    window.overlay.open()

$(document).on 'click', '.js-login-confirm', ->
  window.location = '/auth/facebook'

$(document).on 'click', '.js-login-cancel', ->
  window.overlay.close()
