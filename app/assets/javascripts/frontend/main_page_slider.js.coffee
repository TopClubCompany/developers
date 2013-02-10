class SimpleSlider
  constructor: (@sliderSelector, @slideSelector, @delay = 1000, @showingTime = 10000, @captionDelay = 500) ->
    @slider = $(@sliderSelector)
    @slides = $(@slideSelector)
    @lengthTotal = @slides.length
    #To start slideshow
    @supportsTransitions = (->
      v = ["ms", "Khtml", "O", "Moz", "Webkit", ""]
      return true  if v.pop() + "Transition" of document.body.style  while v.length
      false
    )()
    @bindClick()
    @fadeChange(0, 4000)

  setClass: ->
    @slides.eq(0).addClass('current')
    @slides.eq(1).addClass('upcoming')

  bindClick: () ->
    @slider.siblings('.arrows').on 'click', (e) =>
      jumpTo = (if $(e.target).hasClass('right')
         @number + 1
      else
        jumpTo = if (@number - 1) < 0 then @lengthTotal - 1 else @number - 1)
      clearInterval @showNextSlideId
      @fadeChange jumpTo

  fadeChange: (number = 0, showingTime = @showingTime, delay = @delay) ->
    @number = number
    self = @
    number = number % @lengthTotal

    if @supportsTransitions
      @slides.css
        "-webkit-transition": "opacity #{delay / 1000}s"
        "-khtml-transition": "opactiy #{delay / 1000}s"
        "-moz-transition": "opacity #{delay / 1000}s"
        "-o-transition": "opacity #{delay / 1000}s"
        "transition": "opacity #{delay / 1000}s"
      @slider.find('.caption').css
        "-webkit-transition": "#{@captionDelay / 1000}s"
        "-khtml-transition": "#{@captionDelay / 1000}s"
        "-moz-transition": "#{@captionDelay / 1000}s"
        "-o-transition": "#{@captionDelay / 1000}s"
        "transition": "#{@captionDelay / 1000}s"


      @slides.eq(number).addClass 'upcoming'
      @slides.filter('.current').css
        'opacity': '0'

      setTimeout ( ->
        $(self.slideSelector).filter('.current').removeClass('current')
        $(self.slideSelector).filter('.upcoming').toggleClass('current upcoming')

        self.slides.css
          'opacity': '1'
      ), self.delay

      # we can use @ here for id, but we need self for inner func anyway
      clearTimeout self.showNextSlideId
      self.showNextSlideId = setTimeout ( ->
          self.fadeChange(number + 1)
        ), showingTime
    else
      if @slides.filter('.current').length is 0
        @slides.eq(@number)._addClass 'current'
        setTimeout ( =>
          @fadeChange 1
        ), showingTime
      else
        @slides.eq(number).addClass 'upcoming'

        @slides.filter('.current').animate
          "opacity": "0"
        ,
          duration: delay
          complete: () ->
            $(@).removeClass('current').css('opacity', '1').find('.caption').css('opacity', '0')
            $(self.slideSelector).filter('.upcoming').toggleClass('current upcoming').find('.caption').animate
              'opacity': 0.9
            ,
              duration: @captionDelay
            clearTimeout self.showNextSlideId
            self.showNextSlideId = setTimeout ( ->
              self.fadeChange(number + 1)
            ), showingTime


$ ->
  if $(".slideWrapper").length > 0
    new SimpleSlider(".slideWrapper", "[id^='slide_']", 1000, 4000)
