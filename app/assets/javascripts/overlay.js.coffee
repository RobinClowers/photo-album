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

    @overlay.on 'click', '.js-overlay-close', (event) ->
      self.close()

  open: (target) ->
    @mask.show()
    @setMaskHeight()
    @mask.css('top', window.scrollY)
    @lockScroll()
    @showSpinner()

    @index = $(@selector).index(target)
    overlayContent = $(target).find('.js-overlay-content').clone()
    @overlay.append(overlayContent)

    dimensions = new OverlayDimensions(@overlay.find('.js-overlay-image'))
    dimensions.ready =>
      @setDimensions(dimensions)
      @setButtonVisibility()

      overlayContent.show()
      @overlay.show()
      @spinner.stop()
      overlayContent.trigger('overlay:show')

  setMaskHeight: ->
    @mask.height($(document).height())

  lockScroll: ->
    $('body').addClass('scroll-lock') unless window.mobileLayout()

  showSpinner: ->
    @spinner = new Spinner
      color: '#fff'
    @spinner.spin(@mask[0])

  setButtonVisibility: ->
    if @index >= $(@selector).length - 1
      @overlay.find('.overlay-next').hide()

    if @index == 0
      @overlay.find('.overlay-previous').hide()

  setDimensions: (dimensions) ->
    @overlay.css('left', dimensions.margin())
    @overlay.css('top', dimensions.top())
    @overlay.width(dimensions.width())
    if window.mobileLayout()
      @overlay.find('.js-overlay-image-container').height(dimensions.height())
    else
      @overlay.height(dimensions.height())

    @overlay.find('.js-overlay-image-container').width(dimensions.leftPaneWidth())
    @overlay.find('.js-overlay-caption-container').width(dimensions.leftPaneWidth())
    @overlay.find('.js-overlay-close').css('left', dimensions.width() - 20)

    if dimensions.constrainWidth()
      @overlay.find('.js-overlay-image').width(dimensions.leftPaneWidth())
    else
      @overlay.find('.js-overlay-image').height(dimensions.height())

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

  commentList: ->
    @overlay.find('.js-overlay-comments-container')

  topRight: ->
    @overlay.find('.js-overlay-top-right')

  commentPaneHeight: ->
    @overlay.find('.js-overlay-right').innerHeight() - @topRight().height()

  commentsHeight: ->
    @overlay.find('.js-overlay-comments').height()

  image: ->
    @overlay.find('.js-overlay-image')

  setCommentPaneHeight: =>
    if window.mobileLayout()
      @commentList().height(@commentsHeight())
    else
      @commentList().height(@commentPaneHeight())
      @commentList().scrollTop(@commentsHeight())
      @overlay.find('.js-overlay-image-container').height(@image().height())
