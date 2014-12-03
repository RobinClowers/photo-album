$(document).on 'ajax:success', '[data-subtle-confirmation]', (event, data, status, xhr) ->
  $(this).addClass('ajax-success')

$(document).on 'ajax:error', '[data-subtle-confirmation]', (event, xhr, status, error) ->
  $(this).addClass('ajax-error')
