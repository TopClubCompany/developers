class window.GeoInput
  constructor: (@dom_lat, @dom_lon, @dom_zoom, @defaults={}) ->
    _.defaults(@defaults, {lat: 50.44067063154785, lon: 30.52654266357422, zoom: 12, doom_map: 'admin_map'})
    @lat_el = $('#' + @dom_lat)
    @lon_el = $('#' + @dom_lon);
    @zoom_el = $('#' + @dom_zoom);

    @lat = parseFloat(@lat_el.val()) or @defaults.lat
    @lon = parseFloat(@lon_el.val()) or @defaults.lon
    @zoom = parseInt(@zoom_el.val(), 10) or @defaults.zoom
    @lat_lon = new google.maps.LatLng(@lat, @lon)
    @initGMap()
    @initMarker()

  initGMap: ->
    map_options =
      zoom: @zoom,
      center: @lat_lon,
      mapTypeId: google.maps.MapTypeId.ROADMAP
#      scrollwheel: false

    @map = new google.maps.Map(document.getElementById(@defaults.doom_map), map_options)

    google.maps.event.addListener @map, 'zoom_changed', =>
      @zoom_el.val(@map.getZoom())

  setInputs: (pos) ->
    @lat_el.val(pos.lat())
    @lon_el.val(pos.lng())
    @zoom_el.val(@map.getZoom())


  initMarker: ->
    marker_options =
      position: @lat_lon,
      map: @map,
      draggable: true

    @marker = new google.maps.Marker(marker_options)
    @infowindow = new google.maps.InfoWindow()

    google.maps.event.addListener @marker, 'dragend', (event) =>
      @map.setCenter(event.latLng)
      pos = @marker.getPosition()
      @setInputs(pos)

  initAutocomplete: (dom_input='geo_autocomplete') ->
    input = document.getElementById(dom_input)
    autocomplete = new google.maps.places.Autocomplete(input, {types: ['geocode']})
    google.maps.event.addListener autocomplete, 'place_changed', =>
      place = autocomplete.getPlace()
      return unless place.geometry
      pos = place.geometry.location
      if place.geometry.viewport
        @map.fitBounds(place.geometry.viewport)
      else
        @map.setCenter(pos)
        @map.setZoom(17)

      @marker.setPosition(pos)
      @setInputs(pos)

    $('#'+ dom_input).live "keypress", (e) ->
      if e.keyCode == 13
        e.preventDefault()

window.initGeoInput = (prefix, autocomplete = true) ->
  gmaps = new GeoInput("#{prefix}_lat", "#{prefix}_lon", "#{prefix}_zoom", {doom_map: "#{prefix}_map"})
  gmaps.initAutocomplete("#{prefix}_geo_autocomplete")
