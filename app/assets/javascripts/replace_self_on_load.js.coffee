RunLoop.register ->
  fetchAndReplace = (el, url) ->
    $.get url, (html) ->
      $(el).replaceWith(html)

  for el in $('[data-replace-self-on-load]')
    url = $(el).data('replace-self-on-load')
    $(el).removeAttr('data-replace-self-on-load').trigger('replace:success')
    fetchAndReplace(el, url)
