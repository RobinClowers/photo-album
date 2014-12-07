$(document).on 'ajax:error', (event, xhr, status, error) ->
  if error == 'Unauthorized'
    if confirm 'You need to be logged in to do that. Log in with Facebook now?'
      window.location = '/auth/facebook'
