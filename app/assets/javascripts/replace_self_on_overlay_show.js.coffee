$(document).on 'overlay:show', '.js-overlay', (event, data) ->
  for el in $(this).find('[data-replace-self-on-overlay-show]')
    replaceIf = $(el).data('replace-if')
    continue if replaceIf == "admin" && !window.admin
    url = $(el).data('replace-self-on-overlay-show')
    window.fetchAndReplace el, url, (newEl) =>
      $(newEl).trigger('replace:success')
