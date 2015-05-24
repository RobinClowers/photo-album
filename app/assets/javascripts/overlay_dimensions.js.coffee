class @OverlayDimensions
  commentWidth: 309
  maxPhotoWidth: 1024
  maxPhotoHeight: 768
  minMargin: 10

  constructor: ->
    @totalMargin = @minMargin * 2

  calaculateDimensions: ->
    maxWidth = $(window).width() - @totalMargin
    maxHeight = $(window).height() - @totalMargin

    totalWidth = @maxPhotoWidth + @commentWidth

    if totalWidth > maxWidth
      @width = maxWidth
    else
      @width = totalWidth

    if @maxPhotoHeight > maxHeight
      @height = maxHeight
    else
      @height = @maxPhotoHeight

    heightRatio = @height / @maxPhotoHeight
    widthRatio = @width / @maxPhotoWidth
    @constrainWidth = heightRatio > widthRatio

    if @constrainWidth
      @height = @maxPhotoHeight * widthRatio
    else
      @width = Math.round((@maxPhotoWidth * heightRatio) + @commentWidth)

    @leftPaneWidth = @width - @commentWidth

    @margin = (maxWidth - @width) / 2
    if @margin < 1 then @margin = @minMargin

    @top = window.scrollY + @minMargin
