replaceSelfOnLoad = ->
  for el in $('[data-replace-self-on-load]')
    url = $(el).data('replace-self-on-load')
    $(el).removeAttr('data-replace-self-on-load')
    $.get url, (html) ->
      $(el).replaceWith(html)

setInterval(replaceSelfOnLoad, 100)
