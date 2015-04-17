class @Overlay
  constructor: (selector, options) ->
    @selector = selector
    @options = options
    self = this
    @overlay = $("<div class='overlay octopress-reset'></div>")
    @mask = $("<div class='overlay-mask octopress-reset'></div>")
    $('body').append(@overlay).append(@mask)

    $(@selector).click (event) ->
      event.preventDefault()
      self.open(this)

    @mask.click (event) ->
      self.close()

    $(document).on 'keyup', (event) ->
      return unless event.which == 27
      self.close()

    @overlay.on 'click', '.overlay-next', (event) ->
      self.close()
      self.next()

    @overlay.on 'click', '.overlay-previous', (event) ->
      self.close()
      self.previous()

  open: (target) ->
    @mask.show()
    @mask.height($(window).height())
    @mask.css('top', window.scrollY)

    @index = $(@selector).index(target)
    overlayContent = $(target).find('.js-overlay').clone()
    @overlay.append(overlayContent)
    @setDimensions()
    @setButtonVisibility()

    overlayContent.show()
    @overlay.show()


  setButtonVisibility: ->
    if @index >= $(@selector).length - 1
      @overlay.find('.overlay-next').hide()

    if @index == 0
      @overlay.find('.overlay-previous').hide()

  setDimensions: ->
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

    top = window.scrollY + 10

    @overlay.css('left', margin)
    @overlay.css('top', top)
    @overlay.width(width)
    @overlay.height(height)

    $('body').addClass('scroll-lock')

  close: ->
    @overlay.empty().hide()
    @mask.hide()
    $('body').removeClass('scroll-lock')

  next: ->
    target = $(@selector)[@index + 1]
    @open(target)

  previous: ->
    target = $(@selector)[@index - 1]
    @open(target)
