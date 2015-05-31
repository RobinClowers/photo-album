class @OverlayDomWrapper
  nextButtonSelector: '.js-overlay-next'
  previousButtonSelector: '.js-overlay-previous'
  closeButtonSelector: '.js-overlay-close'
  contentSelector: '.js-overlay-content'

  constructor: ->
    @el = $("<div class='overlay js-overlay octopress-reset'></div>")
    @mask = $("<div class='overlay-mask octopress-reset'></div>")

  previousButton: ->
    @el.find(@previousButtonSelector)

  nextButton: ->
    @el.find(@nextButtonSelector)

  closeButton: ->
    @el.find(@closeButtonSelector)

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

