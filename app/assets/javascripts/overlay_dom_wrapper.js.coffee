class @OverlayDomWrapper
  closeButtonSelector: '.js-overlay-close'

  constructor: ->
    @el = $("<div class='overlay js-overlay octopress-reset'></div>")
    @mask = $("<div class='overlay-mask octopress-reset'></div>")

