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
      center: new google.maps.LatLng(initialData.lat, initialData.lng),
      zoom: 12,
      mapTypeId: google.maps.MapTypeId.ROADMAP

    @map = new google.maps.Map(document.getElementById("map"), mapOptions)
    @addMarkers()

  addMarkers: () =>
    self = @
    $places = $('#map_details_wrapper').find('.place')
    $places.each (index, element) ->
      data = $(element).data()
      marker = new google.maps.Marker(
        position: new google.maps.LatLng(data.lat, data.lng)
        title: "Hello from #{data.id}!"
        html: "<a class='marker' href='#{data.id}' >place</a>"
      )
      marker.setMap(self.map);
      google.maps.event.addListener marker, "mouseover", ->
        selector = '#' + data.id
        console.log selector
        $(selector).addClass 'target'

      google.maps.event.addListener marker, "click", ->
        selector = '#' + data.id
        console.log selector
        console.log $(selector).attr('href')

      google.maps.event.addListener marker, "mouseout", ->
        selector = '#' + data.id
        console.log selector
        $(selector).removeClass 'target'


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
  new SearchForm() if $("#map").size() > 0
