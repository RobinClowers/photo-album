class @Overlay
  constructor: (contentSelector, options) ->
    @contentSelector = contentSelector
    @options = options || {}
    defaults =
      domType: OverlayDomWrapper
      dimensionsType: OverlayDimensions
    @options = $.extend(defaults, @options)
    @dom = new @options.domType()
    $('body').append(@dom.el).append(@dom.mask)

    @createDimensions = ->
      new @options.dimensionsType(@originalContent)

  open: (target) ->
    @prepareOpen(target)
    @setDimensions()
    @show()

  prepareOpen: (target = document) ->
    @dom.mask.show()
    @lockScroll()
    @originalContent = $(target).find(@contentSelector)
    @overlayContent = @originalContent.clone()
    @dom.el.append(@overlayContent)
    @dimensions = @createDimensions()

  setDimensions: ->
    @dom.el.css('left', @dimensions.margin())
    @dom.el.css('top', @dimensions.top())
    @dom.el.width(@dimensions.width())
    @dom.mask.height('100%')
    @dom.closeButton().css('left', @dimensions.closeButtonLeftPosition())

  show: ->
    @overlayContent.show()
    @dom.el.show()
    @overlayContent.trigger('overlay:show')

  setMaskHeight: ->
    @dom.mask.height($(document).height())

  lockScroll: ->
    $('body').addClass('scroll-lock') unless window.mobileLayout()

  close: ->
    @dom.el.empty().hide()
    @dom.mask.hide()
    $('body').removeClass('scroll-lock')
