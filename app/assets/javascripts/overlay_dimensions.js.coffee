class @OverlayDimensions
  commentWidth: 300
  maxPhotoWidth: 1024
  maxPhotoHeight: 768
  minMargin: 10

  constructor: ->
    @totalMargin = @minMargin * 2
    if window.mobileLayout()
      @commentWidth = 0
    else
      @commentWidth = 300

    @heightRatio = ->
      @initialHeight() / @maxPhotoHeight

    @widthRatio = ->
      @initialWidth() / @maxPhotoWidth

    @totalWidthRatio = ->
      @initialWidth() / (@maxPhotoWidth + @commentWidth)

    @maxWidth = ->
      $(window).width() - @totalMargin

    @maxHeight = ->
      $(window).height() - @totalMargin

    @totalWidth = ->
      @maxPhotoWidth + @commentWidth

    @initialWidth = ->
      if @totalWidth() > @maxWidth()
        @maxWidth()
      else
        @totalWidth()

    @initialHeight = ->
      if @maxPhotoHeight > @maxHeight()
        @maxHeight()
      else
        @maxPhotoHeight

    @idealWidth = ->
      Math.round((@maxPhotoWidth * @heightRatio()) + @commentWidth)

    @idealHeight = ->
      Math.round(@maxPhotoHeight * @totalWidthRatio())

  width: ->
    if @constrainWidth()
      @initialWidth()
    else
      @idealWidth()

  height: ->
    if @constrainHeight()
      @initialHeight()
    else
      @idealHeight()

  constrainWidth: ->
    @idealWidth() > @maxWidth() || @heightRatio() > @widthRatio()

  constrainHeight: ->
    @idealHeight() > @maxHeight() || @widthRatio() > @heightRatio()

  leftPaneWidth: ->
    @width() - @commentWidth

  margin: ->
    margin = (@maxWidth() - @width()) / 2
    return margin unless margin < 1
    @minMargin

  top: ->
    window.scrollY + @minMargin
