$(document).on 'ajax:error', (event, xhr, status, error) ->
  if xhr.status == 401
    overlay = new Overlay('#js-login-prompt')
    overlay.open()

$('.js-login-confirm').click ->
  window.location = '/auth/facebook'

$('.js-login-cancel').click ->
  $.fancybox.close()
