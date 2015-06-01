class @OverlayDomWrapper
  closeButtonSelector: '.js-overlay-close'

  constructor: ->
    @el = $("<div class='overlay js-overlay octopress-reset'></div>")
    @mask = $("<div class='overlay-mask octopress-reset'></div>")
    @closeButton = $("<div class='overlay-close js-overlay-close octopress-reset'>&#x00D7</div>")
