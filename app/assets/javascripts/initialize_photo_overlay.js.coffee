$ ->
  window.overlay = new PhotoOverlay('.js-open-overlay')

$(document).on 'overlay:show', '.js-overlay', ->
  window.overlay.setCommentPaneHeight()

$(document).on 'replace:success', '.js-overlay', ->
  window.overlay.setCommentPaneHeight()
