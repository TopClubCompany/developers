class Pagination
  constructor: (total_elements, per_page = 4, @max_visible = 5, @elSelector = '#list_grid_view .paginate') ->
    @$el = $(@elSelector)
    @total_pages = Math.ceil (total_elements / per_page ) || 0
    console.log total_elements, per_page, @total_pages
    if @total_pages > 1
      @bindListener()
      @goTo 1
    else
      @stub()
    @

  bindListener: () ->
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
    page = parseInt(page)
    endPage = Math.min(@total_pages, page + @max_visible)
    startPage = Math.max(endPage - @max_visible, 1)
    if startPage > 1
      @$el.append "<a href='##{page - 1}'>prev</a>"
    for i in [startPage..endPage]
      @$el.append "<a href='##{i}'>#{i}</a>"
    if endPage < @total_pages
      @$el.append "<a href='##{page + 1}'>next</a>"

    $("#{@elSelector} a[href=##{page}]").addClass('current').siblings().removeClass('current')
    @



class PlacesCollection
  constructor: ( blocksThatExist = [], page = 1 ) ->
    number = parseInt($('#total').text())
    console.log number
    new Pagination(number, blocksThatExist.length).goTo(page)
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
    initialData = $('#map_places').data()
    mapOptions =
      center: new google.maps.LatLng(initialData.lat, initialData.lng),
      zoom: 12,
      disableDefaultUI: true,
      zoomControl: true,
      minZoom: 9,
      mapTypeId: google.maps.MapTypeId.ROADMAP
    @map = new google.maps.Map(document.getElementById("map_places"), mapOptions)
    window.googleMap = @map


  useNewData: (json, page) ->
    $('#total').text json.total
    console.log $('#total').text()
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
    I18n = $('#language .active').attr('id')
    properKitchensName = if place.kitchens.length > 18 then place.kitchens.substring(0, 18) + '...' else place.kitchens
    source   = $("#list_place_template").html()
    listBlock = Mustache.to_html(source, place)
    source   = $("#map_place_template").html()
    mapBlock = Mustache.to_html(source, place)
    $el = $('#map_details_wrapper').append(mapBlock)
    $listEl = $(listBlock).insertBefore('#list_grid_view .paginate')
    time = $("select[name=reserve_time]").val()
    updateSingleTime.call(@, time, $el, $listEl)

  updateTime: (time) =>
    #TODO create ajax responder for batch of ids
    #@batchUpdate @ids, time
    window.filter.get 'reserve_time', time
    $('#map_details_wrapper').find('.place').each (index, el) ->
      $el = $(el)
      $listEl = $('#list_' + $(el).attr('id'))
      updateSingleTime.call(@, time, $el, $listEl)

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
    @dirtyHack()


  dirtyHack: () ->
    querystring = window.location.search
    if gon?
      gon["category"] = _.reduce gon["category"], (memo, num) ->
        memo + ',' + num
      gon["category"] = gon["category"] + ''
      needToCheck = _.extend({}, $.deparam(querystring.slice(1)), gon)
    else
      needToCheck = $.deparam querystring.slice(1)
    @getFilterseNeedToTriggerPaginate(needToCheck)

  strip: (obj) ->
    result = {}
    allowed_properties = ["category", "kitchen", "price"]
    for key in allowed_properties
      result[key] = obj[key] if obj[key]?
    result


  getFilterseNeedToTriggerPaginate: (needToCheck) =>
    needToCheck = @strip needToCheck
    for own key, value of needToCheck
      unless $.isArray value
        needToCheck[key] = undefined
        needToCheck[key] = _.flatten([value.split(',')])
    self = @
    alreadyThere = {}
    $('#refine input').each( ->
      type = $(this).data('type')
      alreadyThere[type] = [] if alreadyThere[type] is undefined
      alreadyThere[type].push(parseInt( $(this).val() ))
    )
    needed = {}
    for filter, values of needToCheck
      needed[filter] = false if needed[filter] is undefined
      needed[filter] = true if _.reject(values, (num) ->
        $("#refine input[value='#{num}'][data-type='#{filter}']").click() unless $("#refine input[value='#{num}'][data-type='#{filter}']").is(':checked')
        parseInt(num) in alreadyThere[filter]
      ).length > 0
    for filter, flag of needed
      if flag
        $("a.more[data-type='#{filter}']").click()
        setTimeout(( ->
          self.getFilterseNeedToTriggerPaginate(needToCheck)
        ), 500)
    needed


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
    if entity is 'reserve_date' and oldQuery.match(/reserve_date=(\d+\-){2,}\d+/)
      oldQuery = oldQuery.replace(/reserve_date=(\d+\-){2,}\d+/, '')
      oldQuery = oldQuery.replace(/&{2,}/,'&')
    amp = if oldQuery is '' then '' else '&'
    if (window.location.search.match(regexpMatch))
      newQuery = oldQuery.replace(regexpReplace, paramed)
    else
      newQuery = oldQuery + amp + paramed
    if entity is 'reserve_time'
      newQuery = newQuery.replace(/(\+AM){2,}/, '+AM')
      newQuery = newQuery.replace(/(\+PM){2,}/, '+PM')
      newQuery = newQuery.replace(/\+AM\+PM/, '+PM')
      newQuery = newQuery.replace(/\+PM\+AM/, '+AM')
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
        window.filter.get 'reserve_date', dateText
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
      window.filter.get 'number_of_people', number


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
    $("a.more").one 'click', (e) ->
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
    total = parseInt($('#total').html())
    new Pagination( total )

  $('.timing a').on 'click', (e) ->
    e.preventDefault()
    return false if $(e.target).hasClass('na')
    language = $('#language .active').attr('id')
    date = $("input[name='reserve_date']").val().replace(/\//g,'-')
    id = $(e.target).parents('.place').data('id')
    time = $(e.target).html()
    people = $("select[name=number_of_people]").val()
    newLink = "/#{language}/new_reservation/#{date},#{id},h=#{time.split(':')[0]}&m=#{time.split(':')[1]},#{people}"
    window.location.replace newLink