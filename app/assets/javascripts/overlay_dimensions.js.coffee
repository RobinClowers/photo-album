class @OverlayDimensions
  commentWidth: 300
  minMargin: 10
  closeButtonOffset: 20

  constructor: (image) ->
    @image = image

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

  ready: (callback) ->
    @image.load =>
      nativeImage = new Image()
      nativeImage.src = @image.attr("src")
      @maxPhotoWidth = nativeImage.width
      @maxPhotoHeight = nativeImage.height
      callback()

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

  closeButtonLeftPosition: ->
    @width() - @closeButtonOffset
