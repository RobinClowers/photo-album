RunLoop.register ->
  for el in $('[data-replace-self-on-load]')
    url = $(el).data('replace-self-on-load')
    window.fetchAndReplace el, url, (newEl) =>
      $(newEl).trigger('replace:success')
