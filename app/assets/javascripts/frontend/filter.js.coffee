class PlacesCollection
  constructor: () ->
    @places = {}
    @ids = []
    @createMap()
   
  createMap: () ->
    initialData = $('#map').data()
    mapOptions =
      center: new google.maps.LatLng(initialData.lat, initialData.lng),
      zoom: 12,
      mapTypeId: google.maps.MapTypeId.ROADMAP

    @map = new google.maps.Map(document.getElementById("map"), mapOptions)

  useNewData: (placesData) ->
    newIds = _.pluck(placesData, 'id')
    needToAdd = _.difference newIds, @ids
    needToRemove = _.without @ids, newIds
    console.log needToRemove, needToAdd
    @ids = _.union @ids, needToAdd
    idsPresent = _.pluck placesData, "id"

    
  addPlace: (placeData) ->
    place =
      "id": placeData.id
      "lat": placeData.lat
      "lng": placeData.lng
      "title": placeData.name
      # reviews should state number of reviews, e.g. 1 review, 2 reviews and so on
      "reviews": placeData.reviews
    @addBlock place
    @addMarker place
  
  addBlock: (place) =>
    block = """
      <div id="place_#{place.id}" data-lng="#{place.lng}" data-lat="#{place.lat}" class="place">
        <h4>
          <a href="#">#{place.title}</a>
        </h4>
        <div class="rating">
          <div class="stars">
            <div class="stars_overlay"></div>
            <div class="stars_bar"></div>
            <div class="stars_bg"></div>
          </div>
          <small>#{data.reviews}</small>
        </div>
        <div class="timing">
          <a href="#"></a>
          <a href="#"></a>
          <a href="#" class="bold"></a>
          <a href="#"></a>
          <a href="#"></a>
          <div class="clear"></div>
        </div>
      </div>
    """
    $('#map_details_wrapper').append block
  addMarker: (obj) =>
    marker = new google.maps.Marker(
      position: new google.maps.LatLng(data.lat, data.lng)
      title: "Hello from #{data.id}!"
      html: "<a class='marker' href='##{data.id}'>place</a>"
    )
    marker.setMap(@map);
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

class FilterInput
  constructor: (needToShowMap = no)->
    if needToShowMap
      @places = new PlacesCollection() if $("#map").length > 0
    @checkIfNeeded()
    @bindChangeListener()
    @give_more() if $(".more").length > 0

  checkIfNeeded: () ->
    querystring = window.location.search
    needToCheck = $.deparam querystring.slice(1)
    for filter, values of needToCheck
      for value in values
        $("#refine input[value='#{value}'][data-type='#{filter}']").click() unless $("#refine input[value='#{value}'][data-type='#{filter}']").is(':checked')

  bindChangeListener: () ->
    $('#refine input[type=checkbox]').change ->
      result = {}
      $('#refine input').each( ->
        type = $(this).data('type')
        result[type] = [] if result[type] is undefined
        result[type].push($(this).val()) if $(this).is(':checked')
      )
     
      baseURL =  window.location.pathname
      newQuery = $.param result
      newUrl = (baseURL + '/?' + newQuery).replace('//?', '/?')
      window.history.replaceState('',null, newUrl)
      askAJAX.call(@, newQuery)

  askAJAX = (serializedData) ->
    $.ajaxSetup
       dataType: "json",
       url: "/search/",
       type: "GET"
       error: (xhr, error) ->
         console.log xhr, error
       success: (json) ->
          console.log json
          #console.log @places.useNewData(json)
       beforeSend: () ->
        console.log 'sending ajax request, can do animation here'
       complete: () ->
        console.log 'ajax request completed, can remove animation here'

    $.ajax({ data: serializedData });

  give_more: =>
    @more_template = Handlebars.compile($("#more_template").html())
    self = @
    $("a.more").on 'click', (e) ->
      e.preventDefault()
      $el = $(this)
      type = $el.data('type')
      if type
        $.getJSON '/search/get_more',{type: type}, (data) => parse_more_objects.call(self, data, $el)

  #private methods
  parse_more_objects = (data, $el) ->
    _.each data, (obj) =>
      $el.prev().prev().after(@more_template(obj))
    $el.hide()

$ ->
  if $('#refine').length isnt 0
    new FilterInput(true)

  ###
    ///
      (?<=filters=) # after word filters=
      [\w+%=&\d]*   # look for characters, %, =, &, and digits
    ///
  ###




