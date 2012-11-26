class SearchForm

  constructor: ->
    @createMap()
    @showMap()
    @bind_change_view()

  bind_change_view: =>
    self = @
    $("#view_switch a").on 'click', (e) -> self.change_type_view(e, $(this))

  createMap: () ->

    initialData = $('#map').data()
    mapOptions =
      center: new google.maps.LatLng(initialData.lng, initialData.lat),
      zoom: 12,
      mapTypeId: google.maps.MapTypeId.ROADMAP

    map = new google.maps.Map(document.getElementById("map"), mapOptions)
    @addMarkers()

  addMarkers: () ->


  change_type_view: (e, $el) =>
    e.preventDefault()

    unless $el.hasClass('current')
      $('#grid_view, #map_view').toggleClass('current')
      if $el.attr('id') is 'map_view' then @showMap() else @showList()

  showMap: () =>
    $('#list_grid_view').hide()
    $('#map').add('#map_details').show()

  showList: () =>
    $('#list_grid_view').show()
    $('#map').add('#map_details').hide()


$ ->
  new SearchForm()
