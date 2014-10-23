$(document).on 'ajax:success', '[data-confirmation]', (event, data, status, xhr) ->
  $('.messages').append("<p class='messages-success'>Completed successfully</div>")

$(document).on 'ajax:error', '[data-confirmation]', (event, xhr, status, error) ->
  $('.messages').append("<p class='messages-error'>An error has occured</div>")
