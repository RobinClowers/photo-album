$(document).on 'ajax:success', '[data-confirmation]', (event, data, status, xhr) ->
  $(event.target).find('.messages').append("<p class='notice'>Completed successfully</div>")

$(document).on 'ajax:error', '[data-confirmation]', (event, xhr, status, error) ->
  $(event.target).find('.messages').append("<p class='error'>An error has occured</div>")
