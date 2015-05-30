window.fetchAndReplace = (el, url) ->
  $.get url, (html) ->
    $(el).replaceWith(html)

