window.fetchAndReplace = (el, url, callback) ->
  $.get url, (html) ->
    newEl = $(html)
    $(el).replaceWith(newEl)
    callback(newEl) if callback

