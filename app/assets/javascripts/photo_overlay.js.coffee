$ ->
  overlay = new Overlay('.js-open-overlay')

setCommentPaneHeight = (el) ->
  overlay = $(el)
  topRightHeight = overlay.find('.js-overlay-top-right').height()
  commentPaneHeight = overlay.find('.js-overlay-right').innerHeight() - topRightHeight
  commentList = overlay.find('.js-overlay-comments-container')
  commentsHeight = overlay.find('.js-overlay-comments').height()
  if window.mobileLayout()
    commentList.height(commentsHeight)
  else
    commentList.height(commentPaneHeight)
    commentList.scrollTop(commentsHeight)
    image = overlay.find('img')
    overlay.find('.js-overlay-image-container').height(image.height())

$(document).on 'overlay:show', '.js-overlay', ->
  setCommentPaneHeight(this)

$(document).on 'replace:success', '.js-overlay', ->
  setCommentPaneHeight(this)
