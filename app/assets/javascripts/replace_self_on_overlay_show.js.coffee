$(document).on 'overlay:show', '.js-overlay', (event, data) ->
  for el in $(this).find('[data-replace-self-on-overlay-show]')
    url = $(el).data('replace-self-on-overlay-show')
    window.fetchAndReplace el, url, (newEl) =>
      $(newEl).trigger('replace:success')
