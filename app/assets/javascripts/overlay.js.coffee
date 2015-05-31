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

  prepareOpen: (target) ->
    @dom.mask.show()
    @setMaskHeight()
    @dom.mask.css('top', window.scrollY)
    @lockScroll()
    @overlayContent = $(target).find(@contentSelector).clone()
    @dom.el.append(@overlayContent)
    @dimensions = new @options.dimensionsType(@dom.image())

  open: (target) ->
    @prepareOpen(target)
    @setDimensions()
    @show()

  show: ->
    @overlayContent.show()
    @dom.el.show()
    @overlayContent.trigger('overlay:show')

  setMaskHeight: ->
    @dom.mask.height($(document).height())

  lockScroll: ->
    $('body').addClass('scroll-lock') unless window.mobileLayout()
