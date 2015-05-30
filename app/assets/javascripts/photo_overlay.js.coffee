$ ->
  overlay = new Overlay('.js-open-overlay')

$(document).on 'overlay:visible', '.js-overlay', ->
  overlay = $(this)
  topRightHeight = overlay.find('.js-overlay-top-right').height()
  commentListHeight = overlay.find('.js-overlay-right').innerHeight() - topRightHeight
  overlay.find('.js-overlay-comment-list').height(commentListHeight)
