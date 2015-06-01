@isFormElement = (element) ->
  element.type || $(element).is('[contenteditable]')
