$(document).on 'ajax:error', (event, xhr, status, error) ->
  if error == 'Unauthorized'
    $.fancybox.open
      href: '#js-login-prompt'

$('.js-login-confirm').click ->
  window.location = '/auth/facebook'

$('.js-login-cancel').click ->
  $.fancybox.close()
