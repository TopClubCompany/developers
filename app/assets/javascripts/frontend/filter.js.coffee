class Pagination
  constructor: (total_elements, per_page = 4, @max_visible = 5, @elSelector = '#list_grid_view .paginate') ->
    @$el = $(@elSelector)
    @total_pages = Math.ceil (total_elements / per_page)
    # console.log total_elements, per_page, total_elements / per_page
    if @total_pages > 1
      @bindListener()
      @goTo 1
    else 
#      console.log 'stub', @, @$el
      @stub()
    @

  bindListener: () ->
    # console.log 'binded'
    $("#{@elSelector} a").off 'click'
    setTimeout ( =>
      $("#{@elSelector} a").on 'click', (e) =>      
        e.preventDefault()
        unless $(e.target).hasClass('current')
          pageNum = $(e.target).attr('href').slice(1)
          window.filter.get 'page', pageNum
          @goTo pageNum
    ), 100


    @

  stub: () ->
    @$el.empty()
    @$el.html("<a class='current' href='?#1'>1</a>")

  goTo: (page) ->
    @$el.empty()
    if page > 1 and @total_pages > @max_visible
      @$el.append "<a href='?##{page - 1 }'>Prev</a>" 
    if page > 1 and @total_pages < @max_visible
      @$el.append "<a href='?#1'>1</a>" 
    for i in [page..Math.min(page + @max_visible - 1, @total_pages)]
      @$el.append "<a href='##{i}'>#{i}</a>"
    if @max_visible < @total_pages
      @$el.append "<a href='##{page + 1}'>next</a>"
    
    $("#{@elSelector} a[href=##{page}]").addClass('current').siblings().removeClass('current')
    @
    


class PlacesCollection
  constructor: ( blocksThatExist = [], page = 1 ) ->
    new Pagination(blocksThatExist.length).goTo(page)
    @places = []
    @ids = []
    @createMap()
    @markers = []
    window.googleMarkers = @markers
    for block in blocksThatExist
      obj = 
        id: $(block).data('id')
        lat: $(block).data('lat')
        lng: $(block).data('lng')
      @ids.push obj.id
      @addMarker obj
   
  createMap: () ->
    console.log 'inited GMap'
    initialData = $('#map_places').data()
    mapOptions =
      center: new google.maps.LatLng(initialData.lat, initialData.lng),
      zoom: 9,
      disableDefaultUI: true,
      zoomControl: true,
      minZoom: 2,
      mapTypeId: google.maps.MapTypeId.ROADMAP
    @map = new google.maps.Map(document.getElementById("map_places"), mapOptions)
    window.googleMap = @map


  useNewData: (json, page) ->
#    console.log json
    new Pagination(json.total).goTo(page)
    placesData = json.result
    newIds = _.pluck(placesData, 'id')
    needToAddIds = _.difference newIds, @ids
    needToRemoveIds = _.without @ids, newIds
    # idsPresent = _.pluck placesData, "id"
    if needToAddIds.length > 0
      needToAdd = _.filter(placesData, (place) -> needToAddIds.indexOf(place.id) isnt -1  )
      @multipleAdd($.makeArray(needToAdd))
      @updateTime($("select[name=reserve_time]").val())
    if needToRemoveIds.length > 0  
      @multipleRemove needToRemoveIds

    @ids = _.without(_.union(@ids, needToAddIds), needToRemoveIds)

  multipleAdd: (placesToAdd = []) =>
    #console.log placesToAdd
    _.each placesToAdd, (place) =>
      @places.push place
      coords =  place.lat_lng.split(',')
      if coords.length > 0
        place.lat = coords[0]
        place.lng = coords[1]

      @addMarker place
      @addBlock place

  multipleRemove: (placeIdsToRemove) =>
    for removeId in placeIdsToRemove
      self = @
      markerToRemove = _.filter( self.markers, (marker) -> 
        marker.placeId is removeId) 
      markerToRemove[0]?.setMap(null)
  
      $("#place_#{removeId}").add("#list_place_#{removeId}").fadeOut('fast').remove()
  
  addBlock: (place) =>
    properKitchensName = if place.kitchens.length > 18 then place.kitchens.substring(0, 18) + '...' else place.kitchens
    console.log place
    listBlock = """
    <div class="place" id="list_place_#{place.id}">
        <a href="/places/#{place.id}">
          <img height="100" src="#{place.image_path}" width="140">
        </a>
        <h4><a href="/places/#{place.id}">#{place.name}</a></h4>
        <div class="rating">
          <div class="stars">
            <div class="stars_overlay"></div>
            <div class="stars_bar" style="left: #{place.overall_mark * 20}%"></div>
            <div class="stars_bg"></div>
          </div>
          <small>#{place.review_count}</small>
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
          <a href="/places/#{place.id}">#{place.name}</a>
        </h4>
        <div class="rating">
          <div class="stars">
            <div class="stars_overlay"></div>
            <div class="stars_bar" style="left: #{place.overall_mark * 20}%"></div>
            <div class="stars_bg"></div>
          </div>
          <small></small>
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
    $el = $('#map_details_wrapper').append(mapBlock)
    $listEl = $(listBlock).insertBefore('#list_grid_view .paginate')
    time = $("select[name=reserve_time]").val()
    updateSingleTime.call(@, time, $el, $listEl)
    updateReservationLink.call(@, place, $el, $listEl)
    

  updateDate: (dateText) =>
    window.filter.get 'reserve_date', dateText
    $('#map_details_wrapper').find('.place').each (index, el) ->
      $el = $(el)
      $listEl = $('#list_' + $(el).attr('id'))
      #askAjax for single place being available at specific date
      date = dateText.replace /\//g,'-'
      updateSingleDate.call(@, date, $el, $listEl)

  updateTime: (time) =>
    #TODO create ajax responder for batch of ids
    #@batchUpdate @ids, time
    window.filter.get 'reserve_time', time
    $('#map_details_wrapper').find('.place').each (index, el) ->
      $el = $(el)
      $listEl = $('#list_' + $(el).attr('id'))
      #askAjax for single place being available at specific time

      updateSingleTime.call(@, time, $el, $listEl)
  updatePeople: (number) =>
    window.filter.get 'number_of_people', number
    $('#map_details_wrapper').find('.place').each (index, el) ->
      $el = $(el)
      $listEl = $('#list_' + $(el).attr('id'))
      #askAjax for single place being available at specific time
      updateSinglePerson.call(@, number, $el, $listEl)      

  updateReservationLink = (place, els...) ->
    #http://0.0.0.0:3005/new_reservation/26-12-2012,13,h=10&m=00,3
    if els.length is 2
      [$listEl, $el] = els
    for index in [0..4]     
      date = $("input[name='reserve_date']").val().replace(/\//g,'-')
      id = place.id
      time = $("select[name=reserve_time]").val()
      people = $("select[name=number_of_people]").val()
      newLink = "/new_reservation/#{date},#{id}, h=#{time.split(':')[0]}&m=#{time.split(':')[1]},#{people}"
      $el.find(".timing a:eq(#{index})").attr('href', newLink)
      $listEl.find(".timing a:eq(#{index})").attr('href', newLink)

  updateSingleDate = (date, els...) ->
    if els.length is 2
      [$listEl, $el] = els
    for index in [0..4]  
      oldLink = $el.find(".timing a:eq(#{index})").attr('href')
      newLink = oldLink.replace(/(\d+\-)+\d{4}/, date)
      $el.find(".timing a:eq(#{index})").attr('href', newLink)
      $listEl.find(".timing a:eq(#{index})").attr('href', newLink)

  updateSinglePerson = (number, els...) ->
    if els.length is 2
      [$listEl, $el] = els
    for index in [0..4]
      oldLink = $el.find(".timing a:eq(#{index})").attr('href')
      newLink = oldLink.replace(/\d+$/, number)
      $el.find(".timing a:eq(#{index})").attr('href', newLink)
      $listEl.find(".timing a:eq(#{index})").attr('href', newLink)
            
  updateSingleTime = (time, els...) ->
    if els.length is 2
      [$listEl, $el] = els
    [base_time, minutes] = time.split ':'
    base_time = parseInt base_time
    possibilities = ['00', '15', '30', '45']
    length = possibilities.length
    index = possibilities.indexOf(minutes)
    values = [ "#{base_time + Math.floor( (index + 2) / 4 ) }:#{possibilities[(index + 2) % 4]}",                  
    "#{base_time + Math.floor( (index + 1) / 4 ) }:#{possibilities[(index + 1) % 4]}",
    "#{base_time}:#{minutes}",                  
    "#{base_time - ( if (index - 1) < 0 then 1 else 0 ) }:#{possibilities[(if (index - 1) < 0 then index - 1 + length else index - 1) % 4]}",                  
    "#{base_time - ( if (index - 2) < 0 then 1 else 0 ) }:#{possibilities[(if (index - 2) < 0 then index - 2 + length else index - 2) % 4]}"]
    _.each values, (time, index, values) ->
      oldLink = $el.find(".timing a:eq(#{index})").attr('href')
      oldLink = oldLink.replace(/h=\d+/,"h=#{time.split(':')[0]}")
      newLink = oldLink.replace(/m=\d+/,"m=#{time.split(':')[1]}")
      $el.find(".timing a:eq(#{index})").attr('href', newLink)
      $el.find(".timing a:eq(#{index})").html time
      $listEl.find(".timing a:eq(#{index})").html time

    
  addMarker: (obj) =>
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
  constructor: (needToShowMap = no)->
    if needToShowMap 
      blocksThatExist = $("#map_details_wrapper .place")
      page = @getPageNum()
      @places = new PlacesCollection(blocksThatExist, page) if $("#map_places").length > 0
    @checkIfNeeded()
    @bindChangeListener()
    @give_more() if $(".more").length > 0    

  getPageNum: () ->
    page = window.location.search.match( /page=\d*/)?[0].slice(5) || 1
    # if $(".paginate .current").attr('href') isnt "##{page}" or $(".paginate .current").length is 0
      # $(".paginate a[href=##{page}]").addClass('current')

  get: (entity = 'page', entityTo) =>
    obj = {}
    obj[entity] = entityTo
    paramed = $.param(obj)
    switch entity
      when 'page'
       # /#{entity}=(\d+)/
       regexpMatch = /page=(\d+)/
       regexpReplace = /page=\d+/
      when 'reserve_time'
       regexpMatch = /reserve_time=(\d+\W+\w+)/
       regexpReplace = /reserve_time=(\d+\W+\w+)/       
      when 'number_of_people'
       regexpMatch = /number_of_people=(\d+)/
       regexpReplace = /number_of_people=\d+/
      when 'reserve_date'
       regexpMatch = /reserve_date=(\d+\%+\w+)/
       regexpReplace = /reserve_date=[\d+\%+\w+]*/

    baseURL = window.location.pathname
    oldQuery = window.location.search || ''
    amp = if oldQuery is '' then '' else '&'
    if (window.location.search.match(regexpMatch))
      newQuery = oldQuery.replace(regexpReplace, paramed)          
    else
      newQuery = oldQuery + amp + paramed          
    newUrl = (baseURL + '/?' + newQuery).replace(/\/*\?+/, '?')
    window.history.replaceState('',null, newUrl)
    if entity is 'page' 
      pageTo = entityTo
      askAJAX.call(@, newQuery, @places, pageTo)      

  checkIfNeeded: () ->
    querystring = window.location.search
    needToCheck = $.deparam querystring.slice(1)
    for filter, values of needToCheck
      $("a.more[data-type='#{filter}']").click() if $("#refine[data-type='#{filter}']").length < values.split(',').length
    for filter, values of needToCheck
      for value in values.split(',')
        $("#refine input[value='#{value}'][data-type='#{filter}']").click() unless $("#refine input[value='#{value}'][data-type='#{filter}']").is(':checked')

  bindChangeListener: () =>
    $('#refine input[type=checkbox]').off 'change'
    $('#refine input[type=checkbox]').on 'change', =>
      result = {}
      $('#refine input').each( ->
        type = $(this).data('type')
        result[type] = [] if result[type] is undefined
        result[type].push(parseInt( $(this).val() ) )if $(this).is(':checked')
      )
      newQuery = amp = ''      
      startPage = 1
      for own key, value of result
        if value.length > 0
          _.reduce value, (memo, id) ->
            memo + ',' + id
          amp = if newQuery is '' then '' else '&'
          newQuery = newQuery + amp + "#{key}=#{value}"
      amp = '&' if newQuery.length > 0

      newQuery = newQuery + amp + "page=#{startPage}"                
      date = $("input[name='reserve_date']").val().replace(/\//g,'-')
      # page is always there so no need to check for &
      newQuery = newQuery + "&" + $.param({reserve_date: date})
      newQuery = newQuery + "&" + $.param({reserve_time: $('select[name=reserve_time]').val()})
      newQuery = newQuery + "&" + $.param({number_of_people: $('select[name=number_of_people]').val()}) 
      baseURL =  window.location.pathname
      newUrl = (baseURL + '/?' + newQuery).replace(/\/*\?+/, '?')

      window.history.replaceState('',null, newUrl)
      askAJAX.call(@, newQuery, @places, startPage) 
    
    self = @
    $('input[name="reserve_date"]').data('Zebra_DatePicker').update(
      onSelect: (dateText) ->
        headlineText = $('#mapcontainer > h3:first-child').html().replace(/(\d+\/?){3}(?=,)/, dateText)
        $('#mapcontainer > h3:first-child').html headlineText
        self.places.updateDate dateText
    )

    $("select[name=reserve_time]").on 'change', ->
      time = $(this).val()
      headlineText = $('#mapcontainer > h3:first-child').html().replace(/\d+\:\d+(?=\sfor\s)/, time)
      $('#mapcontainer > h3:first-child').html headlineText
      self.places.updateTime time               
    
    $("select[name=number_of_people]").on 'change', ->          
      number = $(this).val()
      headlineText = $('#mapcontainer > h3:first-child').html().replace(/\d+(?=\speople)/, number)
      $('#mapcontainer > h3:first-child').html headlineText
      self.places.updatePeople number
    

  askAJAX = (serializedData, placesObj, page) =>
    $.ajaxSetup
       dataType: "json",
       url: "/search/",
       type: "GET"
       error: (xhr, error) ->
         $.noop()
#          console.log xhr, error
       success: (json) ->
          placesObj.useNewData(json, page)
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
      if type
        $.getJSON '/search/get_more',{type: type}, (data) => parse_more_objects.call(self, data, $el, type)

  #private methods
  parse_more_objects = (data, $el, type) ->
    _.each data, (obj) =>
      _.extend obj, {type: type}
      $el.prev().prev().after(@more_template(obj))
    @checkIfNeeded()
    @bindChangeListener()
    $el.hide()

$ ->
  if $('#refine').length isnt 0
    window.filter = new FilterInput yes
  if $('.paginate').length isnt 0
    total = parseInt($('.paginate').find('.total').html())
    new Pagination( total )
