class SearchForm

  constructor: ->
    @bind_change_view()

  bind_change_view: =>
    self = @
    $("#view_switch a").on 'click', (e) -> self.change_type_view(e, $(this))

  change_type_view: (e, $el) =>
    e.preventDefault()
    unless $el.hasClass('current')
      $("#view_switch a.current").removeClass('current')
      $el.toggleClass('current')
      if $el.attr('id') == 'map_view'
        $('#list_grid_view').hide()
        $('#listing.span10 #map').show()
        $('#listing.span10 #map_details').show()
      else
        $('#list_grid_view').show()
        $('#listing.span10 #map').hide()
        $('#listing.span10 #map_details').hide()

$ ->
  new SearchForm()