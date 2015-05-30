$ ->
  overlay = new Overlay('.js-open-overlay')

setCommentPaneHeight = (el) ->
  overlay = $(el)
  topRightHeight = overlay.find('.js-overlay-top-right').height()
  commentListHeight = overlay.find('.js-overlay-right').innerHeight() - topRightHeight
  overlay.find('.js-overlay-comment-list').height(commentListHeight)

$(document).on 'overlay:show', '.js-overlay', ->
  setCommentPaneHeight(this)

$(document).on 'replace:success', '.js-overlay', ->
  setCommentPaneHeight(this)
