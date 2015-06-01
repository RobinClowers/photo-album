class @PhotoOverlay extends Overlay
  constructor: (selector, options) ->
    @selector = selector
    defaults =
      domType: PhotoOverlayDomWrapper
      dimensionsType: PhotoOverlayDimensions
    @options = options || {}
    @options = $.extend(defaults, @options)
    super(@options.domType.prototype.contentSelector, @options)
    self = this

    $(@selector).click (event) ->
      event.preventDefault()
      self.open(this)

    @dom.mask.click (event) ->
      self.close()

    $(document).on 'keyup', (event) ->
      return unless event.which == 27
      self.close()

    @dom.el.on 'click', @dom.nextButtonSelector, (event) ->
      self.next()

    @dom.el.on 'click', @dom.previousButtonSelector, (event) ->
      self.previous()

    @dom.el.on 'click', @dom.closeButtonSelector, (event) ->
      self.close()

    @createDimensions = ->
      new @options.dimensionsType(@overlayContent.find('.js-overlay-image'))

  open: (target) ->
    @showSpinner()
    @prepareOpen(target)
    @index = $(@selector).index(target)

    @dimensions.ready =>
      @appendContent()
      @setDimensions(@dimensions)
      @setButtonVisibility()
      @spinner.stop()
      @show()

  showSpinner: ->
    if @isOpen
      @dom.spinnerBox().show()
      @spinner = new Spinner
        color: '#fff'
      @spinner.spin(@dom.spinnerBox()[0])
    else
      @spinner = new Spinner
        color: '#fff'
      @spinner.spin(@dom.mask[0])

  setButtonVisibility: ->
    if @index >= $(@selector).length - 1
      @dom.nextButton().hide()

    if @index == 0
      @dom.previousButton().hide()

  setDimensions: ->
    super()
    if window.mobileLayout()
      @dom.imageContainer().height(@dimensions.height())
    else
      @dom.el.height(@dimensions.height())
      @dom.imageContainer().append(@dom.captionContainer().remove())

    @dom.imageContainer().width(@dimensions.leftPaneWidth())
    @dom.captionContainer().width(@dimensions.leftPaneWidth())

    if @dimensions.constrainWidth()
      @dom.image().width(@dimensions.leftPaneWidth())
    else
      @dom.image().height(@dimensions.height())

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
