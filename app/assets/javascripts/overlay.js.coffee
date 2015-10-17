ESC_KEY_CODE = 27

class @Overlay
  constructor: (options) ->
    @options = options || {}
    defaults =
      domType: OverlayDomWrapper
      dimensionsType: OverlayDimensions
    @options = $.extend(defaults, @options)
    @isOpen = false
    self = this

    @spinner = new Spinner
      color: '#fff'

    @dom = new @options.domType()
    $('body').append(@dom.el).append(@dom.mask)

    @createDimensions = ->
      new @options.dimensionsType(@originalContent)

    @dom.mask.click (event) ->
      self.close()

    $('body').on 'keyup', (event) ->
      return if window.isFormElement(event.target)
      return unless event.which == ESC_KEY_CODE
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

  open: (target = $(document)) ->
    target = $(target)
    @showSpinner()
    @prepareOpen(target)
    @appendContent()
    @setDimensions()
    @show()
    @hideSpinner()

  showSpinner: ->
    if @isOpen
      @dom.spinnerBox().show()
      @spinner.spin(@dom.spinnerBox()[0])
    else
      @spinner.spin($('.center')[0])

  hideSpinner: ->
    @spinner.stop()

  prepareOpen: (target) ->
    @closed = false
    @updateUrl(target)
    @dom.mask.show()
    @setMaskHeight()
    @lockScroll()
    @originalContent = @loadContent(target)
    @overlayContent = @originalContent.clone()
    @dimensions = @createDimensions()

  loadContent: (target) ->
    target.find(@options.contentSelector)

  updateUrl: (target) ->
    url = target.data('url')
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
    @hideSpinner()
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
    history.replaceState({}, document.title, baseUrl)
