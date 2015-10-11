LEFT_ARROW_KEY_CODE = 37
RIGHT_ARROW_KEY_CODE = 39

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

    $('body').on 'keyup', (event) ->
      return if window.isFormElement(event.target)
      switch event.which
        when LEFT_ARROW_KEY_CODE then self.previous()
        when RIGHT_ARROW_KEY_CODE then self.next()

    @dom.el.on 'click', @dom.nextButtonSelector, (event) ->
      self.next()

    @dom.el.on 'click', @dom.previousButtonSelector, (event) ->
      self.previous()

    @createDimensions = ->
      new @options.dimensionsType(@overlayContent.find('.js-overlay-image'))

  open: (target) ->
    target = $(target)
    @showSpinner()
    @prepareOpen(target)
    @index = $(@selector).index(target)

    @dimensions.ready =>
      return if @closed
      @appendContent()
      @setDimensions(@dimensions)
      @setButtonVisibility()
      @hideSpinner()
      @show()

  loadContent: (target) ->
    id = target.data("id")
    $(Template.render(PHOTO_OVERLAY_TEMPLATE,
      photo_url: target.data("src") || ""
      photo_alt: target.data("alt") || ""
      photo_caption: target.data("caption") || ""
      caption_form_path: admin_edit_photo_path(photo_id: id)
      photo_plus_ones_path: photo_plus_ones_path(photo_id: id)
      photo_comments_path: photo_comments_path(photo_id: id)
    ))

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

    @dom.imageContainer().width(@dimensions.leftPaneWidth())

    if @dimensions.constrainWidth()
      @dom.image().width(@dimensions.leftPaneWidth())
    else
      @dom.image().height(@dimensions.height())

  next: ->
    target = $(@selector)[@index + 1]
    return unless target
    @open(target)

  previous: ->
    target = $(@selector)[@index - 1]
    return unless target
    @open(target)

  setCommentPaneHeight: =>
    @setMaskHeight()

    if window.mobileLayout()
      @dom.commentList().height(@dom.comments().height())
    else
      @dom.commentList().height(@dom.rightPane().innerHeight() - @dom.topRight().height())
      @dom.commentList().scrollTop(@dom.comments().height())
      @dom.imageContainer().height(@dom.image().height())
