class @Overlay
  constructor: (selector, options) ->
    @selector = selector
    @options = options
    self = this
    @dom = new OverlayDomWrapper()
    $('body').append(@dom.el).append(@dom.mask)

    $(@selector).click (event) ->
      event.preventDefault()
      self.open(this)

    @dom.mask.click (event) ->
      self.close()

    $(document).on 'keyup', (event) ->
      return unless event.which == 27
      self.close()

    @dom.el.on 'click', @dom.nextButtonSelector, (event) ->
      self.close()
      self.next()

    @dom.el.on 'click', @dom.previousButtonSelector, (event) ->
      self.close()
      self.previous()

    @dom.el.on 'click', @dom.closeButtonSelector, (event) ->
      self.close()

  open: (target) ->
    @dom.mask.show()
    @setMaskHeight()
    @dom.mask.css('top', window.scrollY)
    @lockScroll()
    @showSpinner()

    @index = $(@selector).index(target)
    overlayContent = $(target).find(@dom.contentSelector).clone()
    @dom.el.append(overlayContent)

    dimensions = new OverlayDimensions(@dom.image())
    dimensions.ready =>
      @setDimensions(dimensions)
      @setButtonVisibility()

      overlayContent.show()
      @dom.el.show()
      @spinner.stop()
      overlayContent.trigger('overlay:show')

  setMaskHeight: ->
    @dom.mask.height($(document).height())

  lockScroll: ->
    $('body').addClass('scroll-lock') unless window.mobileLayout()

  showSpinner: ->
    @spinner = new Spinner
      color: '#fff'
    @spinner.spin(@dom.mask[0])

  setButtonVisibility: ->
    if @index >= $(@selector).length - 1
      @dom.nextButton().hide()

    if @index == 0
      @dom.previousButton().hide()

  setDimensions: (dimensions) ->
    @dom.el.css('left', dimensions.margin())
    @dom.el.css('top', dimensions.top())
    @dom.el.width(dimensions.width())
    if window.mobileLayout()
      @dom.imageContainer().height(dimensions.height())
    else
      @dom.el.height(dimensions.height())

    @dom.imageContainer().width(dimensions.leftPaneWidth())
    @dom.captionContainer().width(dimensions.leftPaneWidth())
    @dom.closeButton().css('left', dimensions.width() - 20)

    if dimensions.constrainWidth()
      @dom.image().width(dimensions.leftPaneWidth())
    else
      @dom.image().height(dimensions.height())

  close: ->
    @dom.el.empty().hide()
    @dom.mask.hide()
    $('body').removeClass('scroll-lock')

  next: ->
    target = $(@selector)[@index + 1]
    @open(target)

  previous: ->
    target = $(@selector)[@index - 1]
    @open(target)

  setCommentPaneHeight: =>
    @setMaskHeight()

    if window.mobileLayout()
      @dom.commentList().height(@dom.comments().height())
    else
      @dom.commentList().height(@dom.rightPane().innerHeight() - @dom.topRight().height())
      @dom.commentList().scrollTop(@dom.comments().height())
      @dom.imageContainer().height(@dom.image().height())
