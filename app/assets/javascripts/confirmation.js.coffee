
$(document).on 'ajax:success', '[data-confirmation]', (event, data, status, xhr) ->
  notice = $(this)
    .find('.messages')
    .append("<p class='notice'>Completed successfully</div>")
    .find('.notice')
  setTimeout(( ->
    notice.addClass('fade-out')), 1000)
  setTimeout(( ->
    notice.remove()), 2000)

$(document).on 'ajax:error', '[data-confirmation]', (event, xhr, status, error) ->
  $(this).find('.messages').append("<p class='error'>An error has occured</div>")
