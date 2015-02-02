class @Overlay
  constructor: (selector, options) ->
    @selector = selector
    @options = options
    $(@selector).click @open
    @self = this

  open: (event) ->
    event.preventDefault()
    overlayContent = $(this).find('.js-overlay').remove()


    overlay = $("<div class='overlay'></div>")
    overlay.append(overlayContent)
    overlayContent.show()
    $('body').append(overlay)

    overlay.css('left', '10px')
    overlay.css('top', '10px')
    overlay.width($(window).width() - 20)
    overlay.height($(window).height() - 20)
