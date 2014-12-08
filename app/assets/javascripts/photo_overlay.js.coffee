loadPlusOneButton = (fancybox) ->
  id = fancybox.element.data('photo-id')
  authenticityToken = $('#authenticity_token').val()
  fancybox.title += plusOneButton(id, authenticityToken)

plusOneButton = (id, authenticityToken) ->
  "<div data-replace-self-on-load='/photos/#{id}/plus_ones'></div>"

loadMessagesContainer = ->
  "<div class='messages'></div>"

loadCaptionForm = (fancybox) ->
  if window.admin
    id = fancybox.element.data('photo-id')
    authenticityToken = $('#authenticity_token').val()
    fancybox.title += captionForm(id, fancybox.captionText, authenticityToken)
  else
    fancybox.title += "<div>#{fancybox.captionText}</div>"

captionForm = (id, caption, authenticityToken) ->
  "<form method='post' action='/admin/photos/#{id}' data-remote data-confirmation>
    <input type='hidden' name='_method' value='patch'></input>
    <input type='hidden' name='authenticity_token' value='#{authenticityToken}'></input>
    <label for='caption'>Add caption</label>
    <textarea name='photo[caption]' style='width: 98%'>#{caption}</textarea>
    <input type='submit'>
  </form>"

$ ->
  $(".fancybox").fancybox
    caption:
      type: 'inside'
    afterLoad: ->
      @captionText = @title
      @title = ''
      loadPlusOneButton(this)
      loadCaptionForm(this)
      loadMessagesContainer()
