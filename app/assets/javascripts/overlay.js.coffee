ESC_KEY_CODE = 27

class @Overlay
  constructor: (contentSelector, options) ->
    @contentSelector = contentSelector
    @options = options || {}
    defaults =
      domType: OverlayDomWrapper
      dimensionsType: OverlayDimensions
    @options = $.extend(defaults, @options)
    @isOpen = false
    self = this

    @dom = new @options.domType()
    $('body').append(@dom.el).append(@dom.mask)

    @createDimensions = ->
      new @options.dimensionsType(@originalContent)

    @dom.mask.click (event) ->
      self.close()

    $('body').on 'keyup', (event) ->
      return if window.isFormElement(event.target)
      return unless event.which == ESC_KEY_CODE
      self.hideSpinner()
      self.close()

    @dom.el.on 'click', @dom.closeButtonSelector, (event) ->
      self.close()

    $(window).on 'popstate', (event) ->
      window.photoOverlay.openSelectedItem()

  openSelectedItem: ->
    target = $(".js-open-overlay[data-url='#{window.location.pathname}']")
    if target.length > 0
      @open(target)
    else
      @close()

  open: (target) ->
    @showSpinner()
    @prepareOpen(target)
    @appendContent()
    @setDimensions()
    @show()
    @hideSpinner()

  showSpinner: ->
    if @isOpen
      @dom.spinnerBox().show()
      @spinner = new Spinner
        color: '#fff'
      @spinner.spin(@dom.spinnerBox()[0])
    else
      @spinner = new Spinner
        color: '#fff'
      @spinner.spin($('.center')[0])

  hideSpinner: ->
    @spinner.stop()

  prepareOpen: (target = document) ->
    @closed = false
    @updateUrl(target)
    @dom.mask.show()
    @setMaskHeight()
    @lockScroll()
    @originalContent = $(target).find(@contentSelector)
    @overlayContent = @originalContent.clone()
    @dimensions = @createDimensions()

  updateUrl: (target) ->
    url = $(target).data('url')
    return unless history && history.pushState && url
    return if url == location.pathname
    @urlChanged = true
    history.pushState({}, document.title, url)

  appendContent: ->
    @clear()
    @dom.el.append(@dom.closeButton)
    @dom.el.append(@overlayContent)

  setDimensions: ->
    @dom.el.css('left', @dimensions.margin())
    @dom.el.css('top', @dimensions.top())
    @dom.el.width(@dimensions.width())
    @dom.closeButton.css('left', @dimensions.closeButtonLeftPosition())
    @setMaskHeight()

  show: ->
    @overlayContent.show()
    @dom.el.show()
    @isOpen = true
    @overlayContent.trigger('overlay:show')

  setMaskHeight: ->
    @dom.mask.height($(document).height())

  lockScroll: ->
    $('body').addClass('scroll-lock') unless window.mobileLayout()

  clear: ->
    @dom.el.empty()

  close: ->
    @closed = true
    @resetUrl()
    @clear()
    @dom.el.hide()
    @dom.mask.hide()
    $('body').removeClass('scroll-lock')
    @isOpen = false

  resetUrl: ->
    return unless @urlChanged
    baseUrl = $(document).find('[data-base-url]').data('base-url')
    return unless baseUrl
    history.pushState({}, document.title, baseUrl)
