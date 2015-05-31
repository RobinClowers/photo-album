$(document).on 'ajax:success', '[data-replace-self-on-ajax-success]', (event, data, status, xhr) ->
  newEl = $(data)
  $(this).replaceWith(newEl)
  newEl.trigger('replace:success')

$(document).on 'ajax:error', '[data-replace-self-on-ajax-success]', (event, xhr, status, error) ->
  return unless xhr.status == 422
  newEl = $(xhr.responseText)
  $(this).replaceWith(newEl)
  newEl.trigger('replace:success')
