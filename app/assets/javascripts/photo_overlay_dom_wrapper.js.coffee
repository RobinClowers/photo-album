class @PhotoOverlayDomWrapper extends OverlayDomWrapper
  nextButtonSelector: '.js-overlay-next'
  previousButtonSelector: '.js-overlay-previous'

  previousButton: ->
    @el.find(@previousButtonSelector)

  nextButton: ->
    @el.find(@nextButtonSelector)

  captionContainer: ->
    @el.find('.js-overlay-caption-container')

  imageContainer: ->
    @el.find('.js-overlay-image-container')

  commentList: ->
    @el.find('.js-overlay-comments-container')

  topRight: ->
    @el.find('.js-overlay-top-right')

  image: ->
    @el.find('.js-overlay-image')

  rightPane: ->
    @el.find('.js-overlay-right')

  comments: ->
    @el.find('.js-overlay-comments')

  spinnerBox: ->
    @el.find('.js-overlay-spinner-container')
