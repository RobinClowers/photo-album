class @OverlayDimensions
  commentWidth: 300
  maxPhotoWidth: 1024
  maxPhotoHeight: 768
  minMargin: 10

  constructor: ->
    @totalMargin = @minMargin * 2

    @heightRatio = ->
      @initialHeight() / @maxPhotoHeight

    @widthRatio = ->
      @initialWidth() / @maxPhotoWidth

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

  width: ->
    if @constrainWidth()
      @initialWidth()
    else
      Math.round((@maxPhotoWidth * @heightRatio()) + @commentWidth)

  height: ->
    if @constrainWidth()
      @maxPhotoHeight * @widthRatio()
    else
      @initialHeight()

  constrainWidth: ->
    @heightRatio() > @widthRatio()

  leftPaneWidth: ->
    @width() - @commentWidth

  margin: ->
    margin = (@maxWidth() - @width()) / 2
    return margin unless margin < 1
    @minMargin

  top: ->
    window.scrollY + @minMargin
