class ViewToggler
  constructor: ->
    @showList()
    @bind_change_view()
    @bindScrollMapListener()


  bindScrollMapListener: =>
    $(window).scroll ->
      topOffset = $(window).scrollTop()
      if $("#map_places").is(':visible')
        if topOffset >=  192
          $("#mapcontainer").addClass "fixed"
        else if topOffset < 192
          $("#mapcontainer").removeClass "fixed"

  bind_change_view: =>
    self = @
    $("#view_switch a").on 'click', (e) -> self.change_type_view(e, $(this))

  change_type_view: (e, $el) =>
    e.preventDefault()
    unless $el.hasClass('current')
      $('#grid_view, #map_view').toggleClass('current')
      if $el.attr('id') is 'map_view' then @showMap() else @showList()

  showMap: () =>
    $('#list_grid_view').hide()
    $('#map_places').add('#map_details').show()
    google.maps.event.trigger($("#map_places")[0], 'resize');
    center = new google.maps.LatLng( $("#map_places").data('lat'), $("#map_places").data('lng'))
    window.googleMap.setCenter center
    
  showList: () =>
    $('#list_grid_view').show()
    $('#map_places').add('#map_details').hide()
    if $("#mapcontainer").hasClass "fixed"
      $("#mapcontainer").removeClass "fixed"
      $("#mapcontainer").css "margin-left", "auto"

$ ->
  new ViewToggler() if $("#view_switch").length > 0
