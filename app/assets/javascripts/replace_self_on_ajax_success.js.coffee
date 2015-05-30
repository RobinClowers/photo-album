$(document).on 'ajax:success', '[data-replace-self-on-ajax-success]', (event, data, status, xhr) ->
  newEl = $(data)
  $(this).replaceWith(newEl)
  newEl.trigger('replace:success')
