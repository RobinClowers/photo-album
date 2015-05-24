class @OverlayDimensions
  calaculateDimensions: ->
    maxWidth = $(window).width() - 20
    maxHeight = $(window).height() - 20

    commentWidth = 309
    maxPhotoWidth = 1024
    maxPhotoHeight = 768
    totalWidth = maxPhotoWidth + commentWidth

    if totalWidth > maxWidth
      @width = maxWidth
    else
      @width = totalWidth

    if maxPhotoHeight > maxHeight
      @height = maxHeight
    else
      @height = maxPhotoHeight

    @heightRatio = @height / maxPhotoHeight
    @widthRatio = @width / maxPhotoWidth

    if @heightRatio > @widthRatio
      @height = maxPhotoHeight * @widthRatio
    else if @widthRatio > @heightRatio
      @width = Math.round((maxPhotoWidth * @heightRatio) + commentWidth)

    @leftPaneWidth = @width - commentWidth

    @margin = (maxWidth - @width) / 2
    if @margin < 1 then @margin = 10

    @top = window.scrollY + 10
