class @OverlayDimensions
  minMargin: 10

  constructor: (overlayContent) ->
    @overlayContent = overlayContent
    @totalMargin = @minMargin * 2

    @maxWidth = ->
      $(window).width() - @totalMargin

  width: ->
    @overlayContent.width()

  height: ->
    @overlayContent.height()

  margin: ->
    margin = (@maxWidth() - @width()) / 2
    return margin unless margin < 1
    @minMargin

  top: ->
    window.scrollY + ($(window).height() - @height()) / 2

  closeButtonLeftPosition: ->
    @width() - @closeButtonOffset
