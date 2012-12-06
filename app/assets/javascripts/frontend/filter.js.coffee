class PlacesCollection
  constructor: () ->
    @places = []
    @ids = []
    @createMap()
   
  createMap: () ->
    console.log 'inited GMap'
    initialData = $('#map').data()
    mapOptions =
      center: new google.maps.LatLng(initialData.lat, initialData.lng),
      zoom: 9,
      mapTypeId: google.maps.MapTypeId.ROADMAP
    @map = new google.maps.Map(document.getElementById("map"), mapOptions)

  useNewData: (placesData) ->
    newIds = _.pluck(placesData, 'id')
    needToAddIds = _.difference newIds, @ids
    needToRemoveIds = _.without @ids, newIds

    # idsPresent = _.pluck placesData, "id"
    if needToAddIds.length > 0

      needToAdd = _.find(placesData, (place) -> place.id in needToAddIds)
      @multipleAdd $.makeArray(needToAdd)
    if needToRemoveIds.length > 0  
      @multipleRemove needToRemoveIds

    @ids = _.without(_.union(@ids, needToAddIds), needToRemoveIds)

  multipleAdd: (placesToAdd = []) =>
    _.each placesToAdd, (place) =>
#      console.log 'places', place
      @places.push place
      #TODO REPLACE WITH REAL VALUES
      _.extend place, {lat: 50.44067063154785 + Math.random() * 0.5, lng: 30.52654266357422 + Math.random() * 0.5}
      @addMarker place
      @addBlock place


  multipleRemove: (placeIds) ->
    console.log placeIds


  
  addBlock: (place) =>
 #   console.log "addBlock",  place
    
    block = """
      <div id="place_#{place.id}" data-lng="#{place.lng}" data-lat="#{place.lat}" class="place">
        <h4>
          <a href="#">#{place.name_en}</a>
        </h4>
        <div class="rating">
          <div class="stars">
            <div class="stars_overlay"></div>
            <div class="stars_bar"></div>
            <div class="stars_bg"></div>
          </div>
          <small>#{place.reviews}</small>
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
    console.log 'addedMarker', obj.lat, obj.lng

 #   console.log "addMarker",  obj, "##{obj.id}"
    marker = new google.maps.Marker(
      position: new google.maps.LatLng(obj.lat, obj.lng)
      title: "Hello from #{obj.id}!"
#      html: "<a class='marker' href='##{obj.id}'>place</a>"
    )
    marker.setMap(@map)
    google.maps.event.addListener marker, "mouseover", ->
      selector = '#' + obj.id
      console.log selector
      $(selector).addClass 'target'

    google.maps.event.addListener marker, "click", ->
      selector = '#' + obj.id
      console.log selector
      console.log $(selector).attr('href')

    google.maps.event.addListener marker, "mouseout", ->
      selector = '#' + obj.id
      console.log selector
      $(selector).removeClass 'target'

class FilterInput
  constructor: (needToShowMap = no)->
    if needToShowMap is yes
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

  bindChangeListener: () =>
    $('#refine input[type=checkbox]').change =>
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
      askAJAX.call(@, newQuery, @places)

  askAJAX = (serializedData, placesObj) =>
    $.ajaxSetup
       dataType: "json",
       url: "/search/",
       type: "GET"
       error: (xhr, error) ->
         $.noop()
#          console.log xhr, error
       success: (json) ->
#           console.log json
          placesObj.useNewData(json)
       beforeSend: () ->
         $.noop()
#        sending ajax request, can do animation here'
       complete: () ->
         $.noop()
#        ajax request completed, can remove animation here'

    $.ajax({ data: serializedData });

  give_more: =>
    @more_template = Handlebars.compile($("#more_template").html())
    self = @
    $("a.more").on 'click', (e) ->
      e.preventDefault()
      $el = $(this)
      type = $el.data('type')
      console.log 'request'
      if type
        $.getJSON '/search/get_more',{type: type}, (data) => parse_more_objects.call(self, data, $el, type)

  #private methods
  parse_more_objects = (data, $el, type) ->
		_.extend obj, {type: type}
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




