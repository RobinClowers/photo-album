$ ->
  window.photoOverlay = new PhotoOverlay('.js-open-overlay')

$(document).on 'overlay:show', '.js-overlay', ->
  window.photoOverlay.setCommentPaneHeight()

$(document).on 'replace:success', '.js-overlay', ->
  window.photoOverlay.setCommentPaneHeight()
