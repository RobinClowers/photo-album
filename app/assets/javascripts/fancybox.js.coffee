loadCaptionForm = (fancybox) ->
  return unless window.admin
  id = fancybox.element.data('photo-id')
  caption = fancybox.title
  authenticityToken = $('#authenticity_token').val()
  fancybox.title = captionForm(id, caption, authenticityToken)

captionForm = (id, caption, authenticityToken) ->
  "<form method='post' action='/admin/photos/#{id}' data-remote data-confirmation>
    <input type='hidden' name='_method' value='patch'></input>
    <input type='hidden' name='authenticity_token' value='#{authenticityToken}'></input>
    <label for='caption'>Add caption</label>
    <textarea name='photo[caption]' style='width: 100%'>#{caption}</textarea>
    <input type='submit'>
  </form>
  <div class='messages'></div>"

$ ->
  $(".fancybox").fancybox
    caption:
      type: 'inside'
    afterLoad: ->
      loadCaptionForm(this)
