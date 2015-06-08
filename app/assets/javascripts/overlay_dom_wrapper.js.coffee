class @OverlayDomWrapper
  closeButtonSelector: '.js-overlay-close'

  constructor: ->
    @el = $("<div class='overlay js-overlay'></div>")
    @mask = $("<div class='overlay-mask'></div>")
    @closeButton = $("<div class='overlay-close js-overlay-close'>&#x00D7</div>")
