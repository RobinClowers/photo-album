$(document).on 'ajax:beforeSend', '[data-replace-placeholder-on-submit]', (event, xhr, settings) ->
  form = $(this)
  placeholder = form.data('replace-placeholder-on-submit')
  value = form.find(".#{placeholder}").val()
  settings.url = settings.url.replace(placeholder, value)

