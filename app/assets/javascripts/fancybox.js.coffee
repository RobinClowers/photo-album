captionForm = (id, caption, authenticityToken) ->
  "<form method='post' action='/admin/photos/#{id}'>
    <input type='hidden' name='_method' value='patch'></input>
    <input type='hidden' name='authenticity_token' value='#{authenticityToken}'></input>
    <label for='caption'>Add caption</label>
    <textarea name='photo[caption]' style='width: 100%'>#{caption}</textarea>
    <input type='submit'>
  </form>"

$ ->
  $(".fancybox").fancybox
    caption:
      type: 'inside'
    afterLoad: ->
      return unless window.admin
      id = @element.data('photo-id')
      caption = @title
      authenticityToken = $('#authenticity_token').val()
      @title = captionForm(id, caption, authenticityToken)
