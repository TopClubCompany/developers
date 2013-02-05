class SimpleSlider
  constructor: (@sliderSelector, @slideSelector, @delay = 1000, @showingTime = 10000) ->
    @slider = $(@sliderSelector)
    @slides = $(@slideSelector)
    @lengthTotal = @slides.length
    #To start slideshow
    @supportsTransitions = (->
      v = ["ms", "Khtml", "O", "Moz", "Webkit", ""]
      return true  if v.pop() + "Transition" of document.body.style  while v.length
      false
    )()
#    @bindClick()

    @fadeChange(0, 4000, 0)

  bindClick: () ->
    @slider.find('.indicator').on 'click', (e) =>
      $(e.target).addClass('active').siblings().removeClass('active')
      jumpTo = @getIndex $(e.target).data('target-id')
      @fadeChange jumpTo

  fadeChange: (number = 0, showingTime = @showingTime, delay = @delay) ->
    self = @
    number = number % @lengthTotal
    console.log number
#    unless @slider.find(".indicator:eq(#{number})").hasClass('active')
#      @slider.find(".indicator:eq(#{number})").addClass('active').siblings().removeClass('active')

    if @supportsTransitions
      @slides.css
        "-webkit-transition": "opacity #{delay / 1000}s"
        "-khtml-transition": "opactiy #{delay / 1000}s"
        "-moz-transition": "opacity #{delay / 1000}s"
        "-o-transition": "opacity #{delay / 1000}s"
        "transition": "opacity #{delay / 1000}s"

      @slides.css
        'opacity': '0'

      setTimeout ( ->
        $(self.slideSelector).removeClass('current').addClass('hidden')
        $(self.slideSelector).eq(number).addClass('current').removeClass('hidden')

        self.slides.css
          'opacity': '1'

      ), self.delay
      # we can use @ here for id, but we need self for inner func anyway
      clearTimeout self.showNextSlideId
      self.showNextSlideId = setTimeout ( ->
          self.fadeChange(number + 1)
        ), showingTime
    else
      @slides.each (i, el) ->
        $(el).stop(true,false).animate
          "opacity": "0"
        ,
          duration: delay
          complete: () ->
            if i is number
              $(this).addClass('current').removeClass('hidden')
              $(this).siblings().removeClass('current').addClass('hidden')
            $(this).animate
              "opacity": "1"
            ,
              duration: delay
              complete: clearTimeout self.showNextSlideId; self.showNextSlideId = setTimeout ( ->
                  self.fadeChange(number + 1)
                ), showingTime



  getIndex: (id) ->
    parseInt(id.replace(/slide_/, '')) - 1

$ ->
  if $(".slideWrapper").length > 0
    new SimpleSlider(".slideWrapper", "[id^='slide_']", 1000, 4000)
