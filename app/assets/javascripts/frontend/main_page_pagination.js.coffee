class Paginator
  constructor: (opts) ->
    @initDefaults(opts)
    @bindListener()
    @

  bindListener: () ->
    $(@options.containerId()).find('.load_more').on 'click', (e) =>
      e.preventDefault()
      @htmlToSet = $(e.target).html()
      $(e.target).html("<img src='/assets/ajax_loader_transp.gif'>")
      @next_page()

  initDefaults: (opts) ->
    self = @
    @nextPage = 2
    # options pattern, default values will be overwritten by options object given to constructor
    @defaults =
      # per page
      size: 6
      # already displayer
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
      url: () ->
        "/explore/get_more?" + $.param({ type: self.options.type, size: self.options.size, page: self.nextPage})
      # success callback for request  
      success: (data) ->
        _.each data.result, (place, index) ->
          # main page specific feature
          css_class = if (index+1)%3 is 0 then 'margin_right_place' else ''
          _.extend place, {css_class: css_class}
          # rendering template and appending it 
          source   = $(self.options.templateId).html()
          place = Mustache.to_html(source, place)
          $(self.options.containerId()).append(place)
   
        # finding button, which triggers next page request
        showMoreButton = $(self.options.containerId()).find(self.options.button)
        clear = showMoreButton.siblings('.clear')
   
        self.options.displayed = self.options.displayed + data.result.length
        if self.options.displayed is data.total
          showMoreButton.remove()
        else
          # reseting gif image of loader with html previously saved
          showMoreButton.html(self.htmlToSet)
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

$ ->
  if $('.load_more').length
    $('.load_more').each (index, element) ->
      new Paginator({type: $(element).data('type'), displayed: $(element).data('displayed')})
