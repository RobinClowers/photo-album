$(document).on 'ajax:success', '[data-replace-self-on-ajax-success]', (event, data, status, xhr) ->
  $(this).replaceWith(data)

