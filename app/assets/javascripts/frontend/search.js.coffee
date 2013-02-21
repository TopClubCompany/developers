class ViewToggler
  constructor: ->
    @showList()
    @bind_change_view()
    @bindScrollMapListener()


  bindScrollMapListener: =>
    $(window).scroll ->
      topOffset = $(window).scrollTop() - 50
      if $("#map_places").is(':visible')
        if topOffset >= $("#mapcontainer").offset().top - 70 and not $("#mapcontainer").hasClass("fixed")
          $("#mapcontainer").addClass "fixed"
          $("#mapcontainer").css "margin-left", "-" + ($("#mapcontainer").width() / 2 - 28)  + "px"
        if topOffset <= 250 and $("#mapcontainer").hasClass("fixed")
          $("#mapcontainer").removeClass "fixed"
          $("#mapcontainer").css "margin-left", "auto"

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
