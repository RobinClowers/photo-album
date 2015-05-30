class @Overlay
  constructor: (selector, options) ->
    @selector = selector
    @options = options
    self = this
    @overlay = $("<div class='overlay js-overlay octopress-reset'></div>")
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
    overlayContent = $(target).find('.js-overlay-content').clone()
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
    dimensions = new OverlayDimensions()

    @overlay.css('left', dimensions.margin())
    @overlay.css('top', dimensions.top())
    @overlay.width(dimensions.width())
    @overlay.height(dimensions.height())
    @overlay.find('.js-overlay-image-container').width(dimensions.leftPaneWidth())

    if dimensions.constrainWidth()
      @overlay.find('.js-overlay-image').width(dimensions.leftPaneWidth())
    else
      @overlay.find('.js-overlay-image').height(dimensions.height())

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
