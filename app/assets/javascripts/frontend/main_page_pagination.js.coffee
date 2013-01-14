# class Paginator
#   constructor: (opts) ->
#     @initDefaults(opts)
#     @bindListener()
#     @

#   bindListener: () =>
#     $('.load_more').on 'click', () =>
#       @next_page()
#   initDefaults: (opts) =>
#     self = @
#     @nextPage = 2
#     @defaults =
#       size: 6
#       displayed: 0
#       button: '.load_more'
#       type: 'best'
#       templateId: "#place_template"
#       containerId: () ->
#         '#' + self.options.type
#       url: () ->
#         "/explore/get_more?" + $.param({ type: self.options.type, size: self.options.size, page: self.nextPage})
#       success: (data) ->
#         _.each data.result, (place, index) ->
#           css_class = if (index+1)%3 is 0 then 'margin_right_place' else ''
#           _.extend place, {css_class: css_class}
#           source   = $(self.options.templateId).html()
#           place = Mustache.to_html(source, place)
#           $(self.options.containerId()).append(place)
        
#         showMoreButton = $(self.options.containerId()).find(self.options.button)
#         clear = showMoreButton.siblings('.clear')
#         self.options.displayed = self.options.displayed + data.result.length
#         if self.options.displayed is data.total
#           showMoreButton.remove()
#         else
#           showMoreButton.add(clear).detach().appendTo($(self.options.containerId()))
#           self.nextPage = self.nextPage + 1
  
        

#     options =  _.extend {}, @defaults, opts
#     console.log 'lol', self.options

#   next_page: () ->
#     self = @
#     console.log @options.url()
#     $.ajax
#       type: "GET"
#       url: self.options.url()
#       dataType: "json"
#       success: self.options.success

# $ ->
#   if $('.load_more').length
#     $('.load_more').each (index, element) ->
#       new Paginator({type: $(element).data('type'), displayed: $(element).data('displayed')})
