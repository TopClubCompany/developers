#Class Paginator
#  constructor: () ->
#    @defaults =
#      size: 6
#      type: 'best'
#      templateId: "#place_template"
#      containerId: () ->
#        '#' + @options.type
#      url: () ->
#        "/explore/get_more?" + $.param({ type: @options.type, size: @options.size})
#      success: (data) =>
#        _.each data.result, (place, index) ->
#          css_class = if (index+1)%3 is 0 then 'margin_right_place' else ''
#          _.extend place, {css_class: css_class}
#          source   = $(@options.templateId).html()
#          place = Mustache.to_html(source, place)
#          $(@options.containerId()).append place
#
#    switch action
#      when 'create'
#        @options =  _.extend {}, @defaults, opts
#
#      when 'next'
#        self = @
#        console.log @options.url()
#        $.ajax
#          type: "GET"
#          url: self.options.url()
#          dataType: "json"
#          success: self.options.success
#
#
#
#  @
#
#$ ->
#  Paginator
