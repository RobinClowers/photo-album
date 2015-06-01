class @Overlay
  constructor: (contentSelector, options) ->
    @contentSelector = contentSelector
    @options = options || {}
    defaults =
      domType: OverlayDomWrapper
      dimensionsType: OverlayDimensions
    @options = $.extend(defaults, @options)
    @isOpen = false
    @dom = new @options.domType()
    $('body').append(@dom.el).append(@dom.mask)

    @createDimensions = ->
      new @options.dimensionsType(@originalContent)

  open: (target) ->
    @prepareOpen(target)
    @appendContent
    @setDimensions()
    @show()

  prepareOpen: (target = document) ->
    @dom.mask.show()
    @lockScroll()
    @originalContent = $(target).find(@contentSelector)
    @overlayContent = @originalContent.clone()
    @dimensions = @createDimensions()

  appendContent: ->
    @clear()
    @dom.el.append(@dom.closeButton)
    @dom.el.append(@overlayContent)

  setDimensions: ->
    @dom.el.css('left', @dimensions.margin())
    @dom.el.css('top', @dimensions.top())
    @dom.el.width(@dimensions.width())
    @dom.mask.height('100%')
    @dom.closeButton.css('left', @dimensions.closeButtonLeftPosition())

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
    @clear()
    @dom.el.hide()
    @dom.mask.hide()
    $('body').removeClass('scroll-lock')
    @isOpen = false
