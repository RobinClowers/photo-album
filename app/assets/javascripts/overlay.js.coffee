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
    $('body').append(overlay)

    maxWidth = $(window).width() - 20
    maxHeight = $(window).height() - 20

    commentWidth = 309
    maxPhotoWidth = 1024
    maxPhotoHeight = 768
    totalWidth = maxPhotoWidth + commentWidth

    if totalWidth > maxWidth
      width = maxWidth
    else
      width = totalWidth

    if maxPhotoHeight > maxHeight
      height = maxHeight
    else
      height = maxPhotoHeight

    heightRatio = height / maxPhotoHeight
    widthRatio = width / maxPhotoWidth

    if heightRatio > widthRatio
      height = maxPhotoHeight * widthRatio
    else if widthRatio > heightRatio
      width = (maxPhotoWidth * heightRatio) + commentWidth

    margin = (maxWidth - width) / 2

    overlay.css('left', margin)
    overlay.css('top', '10px')
    overlay.width(width)
    overlay.height(height)

    overlayContent.show()
