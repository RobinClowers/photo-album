RunLoop.register ->
  for el in $('[data-replace-self-on-load]')
    url = $(el).data('replace-self-on-load')
    $(el).removeAttr('data-replace-self-on-load').trigger('replace:success')
    window.fetchAndReplace(el, url)
