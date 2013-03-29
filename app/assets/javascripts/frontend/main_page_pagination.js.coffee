class Paginator
  constructor: (opts) ->
    @initDefaults(opts)
    @bindListener()
    @

  bindListener: () ->
    $(@options.containerId()).find('.load_more').on 'click', (e) =>
      e.preventDefault()
      @htmlToSet = $(e.target).html()
      # $(e.target).html("<img src='/assets/ajax_loader_transp.gif'>")
      $(e.target).hide().after("<img id='js-spinner' src='/assets/ajax-loader.gif'>")
      $("#js-spinner").css
        "display":"block",
        "margin": "auto"
      @next_page()

  initDefaults: (opts) ->
    self = @
    @nextPage = 2
    # options pattern, default values will be overwritten by options object given to constructor
    @defaults =
      # after what number of items we append div.clear
      clearSize: 3
      # whether we append div.clear
      clear: false
      # per page
      size: 6
      # already displayed
      displayed: 0
      # button selector
      button: '.load_more'
      # additional parameter passed to ajax request
      type: 'best'
      # Mustache template wrapper id
      templateId: "#place_template"
      # jQuery id
      containerId: () ->
        '#' + self.options.type
      # url with parameters for request
      baseUrl: "/explore/get_more?"
      url: () ->
        if window.language != "ru"
          self.options.baseUrl = "/" + window.language + "/explore/get_more?"
        self.options.baseUrl + $.param({ type: self.options.type, size: self.options.size, page: self.nextPage})
      # success callback for request  
      success: (data) ->
        data.result = [] unless data.result?
        _.each data.result, (place, index) ->
          # main page specific feature
          css_class = if (index+1)%3 is 0 then 'margin_right_place' else ''
          _.extend place, {css_class: css_class}
          # rendering template and appending it 
          source   = $(self.options.templateId).html()
          place = Mustache.to_html(source, place)
          place = place + "<div class='clear non-movable'></div>" if (self.options.clear and ((index + 1) % self.options.clearSize is 0))
          $(self.options.containerId()).append(place)

   
        # finding button, which triggers next page request
        showMoreButton = $(self.options.containerId()).find(self.options.button)
        clear = showMoreButton.siblings('.clear').not('.non-movable')

        self.options.displayed = self.options.displayed + data.result.length
        if self.options.displayed is data.total or not data.total?
          showMoreButton.remove()
          $("#js-spinner")?.remove()
        else
          # reseting gif image of loader with html previously saved
          showMoreButton.show().html(self.htmlToSet)
          $("#js-spinner").remove()
          showMoreButton.add(clear).detach().appendTo($(self.options.containerId()))
          self.nextPage = self.nextPage + 1


    @options =  _.extend {}, @defaults, opts


  next_page: () ->
    self = @
    $.ajax
      type: "GET"
      url: self.options.url()
      dataType: "json"
      success: self.options.success
      error: self.options.error
$ ->
  if $('.load_more').length
    $('.load_more').each (index, element) ->
      new Paginator($(element).data())

  if $('#search_form').length > 0 and $('#refine').length == 0
    $('select[name=reserve_time]').on 'change.mainPage', (e) ->
      dateText = $('input[name="reserve_date"]').val()
      date = new Date()
      res = []
      res.push curr_date = if (day = date.getDate()) < 10 then '0' + day else day
      res.push curr_month = if (month = date.getMonth() + 1) < 10 then '0' + month else month  #Months are zero based
      res.push curr_year = date.getFullYear()
      time = $(this).val()
      need_suffex = true if time.match(/(AM|PM)/)
      dateToCompare = new Date("#{time} #{date.getMonth() + 1}/#{date.getDate()}/#{date.getFullYear()}")
      if (dateText == res.join('-') or dateText == res.join('/')) and (date >= dateToCompare)
        alert "The time has passed. Please select current time."
        # the last bit for 00, 30 part
        valid_date = new Date(date.setMinutes(date.getMinutes() + 90 - date.getMinutes() % 30))
        valid_hours = valid_date.getHours()
        valid_minutes = ["00", "30"][(valid_date.getMinutes() / 30)]
        if need_suffex
          suffex = (if (valid_hours >= 12) then " PM" else " AM")
          valid_hours = (if (valid_hours > 12) then valid_hours - 12 else valid_hours)
          valid_hours = (if (valid_hours is "00") then 12 else valid_hours)
          validHourString = valid_hours + ":" + valid_minutes + suffex
        else
          validHourString = valid_hours + ":" + valid_minutes
        $(this).val(validHourString)