class PlacesCollection
  constructor: (blocksThatExist = [], @language) ->
    console.log "blocksThatExist", blocksThatExist.data()
    @places = []
    @ids = []
    @createMap()
    @markers = []
   
  createMap: () ->
    console.log 'inited GMap'
    initialData = $('#map_places').data()
    mapOptions =
      center: new google.maps.LatLng(initialData.lat, initialData.lng),
      zoom: 9,
      minZoom: 2,
      mapTypeId: google.maps.MapTypeId.ROADMAP
    @map = new google.maps.Map(document.getElementById("map_places"), mapOptions)

  useNewData: (json) ->
    total = json.total
    placesData = json.result
    newIds = _.pluck(placesData, 'id')
    needToAddIds = _.difference newIds, @ids
    needToRemoveIds = _.without @ids, newIds
    console.log placesData, needToAddIds, needToRemoveIds, @ids
    # idsPresent = _.pluck placesData, "id"
    if needToAddIds.length > 0

      needToAdd = _.filter(placesData, (place) -> needToAddIds.indexOf(place.id) isnt -1  )
      console.log needToAdd
      @multipleAdd $.makeArray(needToAdd)
    if needToRemoveIds.length > 0  
      @multipleRemove needToRemoveIds

    @ids = _.without(_.union(@ids, needToAddIds), needToRemoveIds)

  multipleAdd: (placesToAdd = []) =>
    _.each placesToAdd, (place) =>
      @places.push place
      coords =  place.lat_lng.split(',')
      if coords.length > 0
        place.lat = coords[0]
        place.lng = coords[1]

      @addMarker place
      @addBlock place

  multipleRemove: (placeIds) =>
    for removeId in placeIds
      _.select(@markers,{placeId: removeId}).setMap(null)
      $("#place_#{removeId}").add("#list_place_#{removeId}").remove()
  
  addBlock: (place) =>
    console.log place
    
    properKitchensName = if place.kitchens.length > 18 then place.kitchens.substring(0, 18) + '...' else place.kitchens
    
    listBlock = """
    <div class="place" id="list_place_#{place.id}">
        <a href="/places/#{place.id}">
          <img height="100" src="#{place.image_path}" width="140">
        </a>
        <h4><a href="#"></a></h4>
        <div class="rating">
          <div class="stars">
            <div class="stars_overlay"></div>
            <div class="stars_bar" style="left: #{place.overall_mark * 20}%"></div>
            <div class="stars_bg"></div>
          </div>
          <small>2</small>
        </div>
        <ul class="place_features">
          <li class="location">Ивана Мазепы улица</li>
          <li class="cuisine" title="#{place.kitchens_names}">#{properKitchensName}</li>
          <li class="pricing">#{place.avg_bill_title}</li>
        </ul>
        <div class="timing">
          <a href="#"></a>
          <a href="#"></a>
          <a class="bold" href="#"></a>
          <a href="#"></a>
          <a href="#"></a>
        </div>
        <div class="special_offers">
          <h5>Special offers:</h5>
          <h5>
            <a href="#"></a>
            <a href="#"></a>
            <a href="#"></a>
          </h5>
        </div>
        <div class="clear"></div>
      </div>             
              
    """
    mapBlock = """
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
    $('#map_details_wrapper').append mapBlock
    

#    $("#list_grid_view").append listBlock
    $(listBlock).insertBefore('#list_grid_view .paginate')

    
  addMarker: (obj) =>
    console.log 'addedMarker', obj.lat, obj.lng

 #   console.log "addMarker",  obj, "##{obj.id}"
    marker = new google.maps.Marker(
      position: new google.maps.LatLng(obj.lat, obj.lng)
      title: "Hello from #{obj.id}!"
      placeId: obj.id
      html: "<a class='marker' href='##{obj.id}'>place</a>"
    )
    @markers.push marker
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
  constructor: (needToShowMap = no, language = 'en')->
    if needToShowMap 
      blocksThatExist = $("#map_details_wrapper .place")
      @places = new PlacesCollection(blocksThatExist, language) if $("#map_places").length > 0
    @checkIfNeeded()
    @bindChangeListener()
    @give_more() if $(".more").length > 0

  checkIfNeeded: () ->
    querystring = window.location.search
    askAJAX.call(@, querystring, @places) if querystring isnt '?' and @places?
    needToCheck = $.deparam querystring.slice(1)
    for filter, values of needToCheck
      for value in values
        $("#refine input[value='#{value}'][data-type='#{filter}']").click() unless $("#refine input[value='#{value}'][data-type='#{filter}']").is(':checked')

  bindChangeListener: () =>
    $('#refine input[type=checkbox]').off 'change'
    $('#refine input[type=checkbox]').on 'change', =>
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
    ###
    $("select[name=reserve_time]").on 'change', =>
      time = $(this).val()
      $('#map_details_wrapper').add('#list_grid_view').find('.place').each (index, el) ->
        el.find('.timing a').each (index, el) ->
          console.log time
  
    $("select[name=number_of_people]").on 'change', =>          
      number = $(this).val()
      console.log headline = $('#listing > h3:first-child')
      headlineText = $('#listing > h3:first-child').html()
      console.log headlineText
    ###




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
    _.each data, (obj) =>
      _.extend obj, {type: type}
      $el.prev().prev().after(@more_template(obj))
    @bindChangeListener()
    $el.hide()

$ ->
  language = $("#language li.active").attr('id')
  if $('#refine').length isnt 0
    new FilterInput(yes, language)

  ###
    ///
      (?<=filters=) # after word filters=
      [\w+%=&\d]*   # look for characters, %, =, &, and digits
    ///
  ###




