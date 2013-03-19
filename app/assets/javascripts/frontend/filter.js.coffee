class Pagination
  constructor: (@total_elements, per_page = 10, @max_visible = 5, @elSelector = '#list_grid_view .paginate') ->
    @$el = $(@elSelector)
    @total_pages = Math.ceil (@total_elements / per_page ) || 0
    console.log @total_elements, per_page, @total_pages
    if @total_pages > 1
      @bindListener()
      @goTo 1
    else
      @stub()
    @

  bindListener: () ->
    $("#{@elSelector} a").off 'click.page'
    setTimeout ( =>
      $("#{@elSelector} a").on 'click.page', (e) =>
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
    if @total_elements is 0
      @stub()
    else
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
    new Pagination(number).goTo(page)
    objArray = []
    @places = []
    @ids = []
    @markers = []
    for block in blocksThatExist
      objArray.push $(block).data()
      id = $(block).data('id')
      @ids.push id
      $el = $("#place_#{id}")
      $listEl = $("#list_place_#{id}") 
      bindBlockListeners.call @, $listEl, $el

      $el.add($listEl).find('.timing').each (index, timeGroup) ->
        $(timeGroup).find('a').each (index, timeButton) ->
          timeButton = $(timeButton)
          if index isnt 2
            text = timeButton.text()
            text = text.replace /AM|PM/, ''
          else
            text = timeButton.text()
          timeButton.data('value', timeButton.text())
          timeButton.text(text)
        
    lattitudes = _.pluck objArray, 'lat'
    longtitudes = _.pluck objArray, 'lat'


    window.googleMarkers = @markers
    @createMap()




    for obj in objArray
      @addMarker obj
    setTimeout((=> 
      @adjustMap() if @ids.length > 3
    ), 500)
  createMap: () ->
    initialData = $('#map_places').data()
    center = new google.maps.LatLng(initialData.lat, initialData.lng)
    mapOptions =
#      center: center,
      zoom: 12,
      disableDefaultUI: true,
      zoomControl: true,
      minZoom: 8,
      mapTypeId: google.maps.MapTypeId.ROADMAP
    @map = new google.maps.Map(document.getElementById("map_places"), mapOptions)
    
    window.googleMap = @map



  useNewData: (json, page) ->
    $('.popoverable').popover('hide')
    $('#total').text json.total
    new Pagination(json.total).goTo(page)
    placesData = json.result
    newIds = _.pluck(placesData, 'id')
    needToAddIds = _.difference newIds, @ids
    needToRemoveIds = _.without @ids, newIds
    # idsPresent = _.pluck placesData, "id"
    if needToAddIds.length > 0
      needToAdd = _.filter(placesData, (place) -> needToAddIds.indexOf(place.id) isnt -1  )
      @multipleAdd($.makeArray(needToAdd))
      setTimeout((=> 
        @adjustMap() if @ids.length > 3
      ), 500)
      
    if needToRemoveIds.length > 0
      @multipleRemove needToRemoveIds

    @ids = _.without(_.union(@ids, needToAddIds), needToRemoveIds)

    setTimeout((=>
      @updateOffers placesData
      @updateTime placesData
    ), 50)

  adjustMap: () =>
    bounds = new google.maps.LatLngBounds()
    for marker in @markers
      bounds.extend marker.position
    @map.fitBounds bounds
  
  average = (arr) ->
    _.reduce(arr, (memo, num) ->
      memo + num
    , 0) / arr.length

  multipleAdd: (placesToAdd = []) =>
    _.each placesToAdd, (place) =>
      @places.push place
      coords =  place.lat_lng.split(',')
      if coords.length > 0
        place.lat = coords[0]
        place.lng = coords[1]
      @addBlock place
      @addMarker place
    @handleLikeClick()

  handleLikeClick: ->
    $('.add_to_favorites').off 'click' 
    $('.add_to_favorites').on 'click', ->
      if gon?.current_user
        $(this).toggleClass 'i_like_this_place'
        if $(this).hasClass('i_like_this_place')
          $(this).parent().css('display', 'block')
        else
          $(this).parent().removeAttr('style')
        $.post("/set_unset_favorite_place/#{$(this).data('id')}")
      else
        window.location.replace "/users/sign_in"


  multipleRemove: (placeIdsToRemove) =>
    for removeId in placeIdsToRemove
      self = @
      markerToRemove = _.filter( self.markers, (marker) ->
        marker.placeId is removeId)
      if markerToRemove.length > 0
        _.each markerToRemove, (marker) ->
          marker?.setMap(null)
      else
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
    $el.add($listEl).find('.timing').each (index, timeGroup) ->
      $(timeGroup).find('a').each (index, timeButton) ->
        timeButton = $(timeButton)
        if index isnt 2
          text = timeButton.text()
          text = text.replace /AM|PM/, ''
        else
          text = timeButton.text()
        timeButton.data('value', timeButton.text())
        timeButton.text(text)

    setTimeout(( =>
      bindBlockListeners.call @, $("#list_place_#{place.id}"), $("#place_#{place.id}")
    ), 50)



  bindBlockListeners = (elList, elMap) ->
    $(elMap).add(elList).find(".popoverable").on('click', () -> return false).popover(html: true)
    $(elMap).add(elList).find("h4 > a, .place_img_sm").off 'click'
    $(elMap).add(elList).find("h4 > a, .place_img_sm").on 'click', (e) ->
      e.preventDefault()
      target = if $(e.target).attr('href') then $(e.target) else $(e.target).parent('.place_img_sm')
      searchQuery = window.location.search

      if searchQuery.match(/reserve_date=(\d+\-){2,}\d+/)
        dateString = searchQuery.match(/reserve_date=(\d+\-){2,}\d+/)[0]
        dateString = dateString.replace(/-/g, '%2F')
        searchQuery = searchQuery.replace(/reserve_date=(\d+\-){2,}\d+/, dateString).replace(/&{2,}/,'&')

      [params, match] = ['?', 0]
      for regexp in [/number_of_people=(\d+)/,/reserve_date=[\d+\%+\w+]*/]
        if exactMatch = searchQuery.match(regexp)?[0]
          params += exactMatch + '&'
          match  += 1
      params += $.param({"reserve_time": $("select[name='reserve_time']").val()}) 
      params = "?" + $.param({"reserve_time": $("select[name='reserve_time']").val()}) if match is 0 and $(e.target).parents(elMap).length
      newUrl = target.attr('href') + params
      newUrl +=  '&is_trim=true' if match is 2

      window.history.pushState '', null, window.location.search
      window.location.replace newUrl

  updateOffers: (placesData) =>
    $('#map_details_wrapper').find('.place').each (index, el) ->
      $el = $(el)
      $listEl = $('#list_' + $(el).attr('id'))
      place = _.find(placesData, (place) -> parseInt(place.id) == $(el).data('id'))
      $el.add($listEl).find(".special_offers").empty()

      if place.special_offer
        $el.add($listEl).find(".special_offers").append("<h5>#{I18n.translations["#{window.language}"].admin_js.special_offers}:</h5>")

        for offer in place.special_offers
          # console.log offer

          $a = $("<h5><a class='popoverable' href='#{place.place_url}'>#{offer.popover_data.title}</a></h5>")
            .appendTo($el.add($listEl).find(".special_offers"))
          for key, value of offer.popover_data
            $a.data("#{key}", "#{value}")
          $a.click (e) -> e.preventDefault()
          $a.popover()
      # console.log 'updatedOffers'

  updateTime: (placesData) =>
    $('#map_details_wrapper').find('.place').each (index, el) ->
      time = _.find(placesData, (place) -> parseInt(place.id) == $(el).data('id'))?.timing
      if time
        $el = $(el)
        $listEl = $('#list_' + $(el).attr('id'))
        updateSingleTime.call(@, time, $el, $listEl)
        setTimeout(( ->
          bindBlockListeners.call(@, $listEl, $el)
        ), 50)

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

  updateSingleTime = (values, $el, $listEl, index) ->
    _.each values, (time, index, values) ->
      if index isnt 2
        text = time.time
        text = text.replace /AM|PM/, ''        
      else 
        text = time.time
      $el.find(".timing a:eq(#{index})").html(text).data('value', time.time)
      $listEl.find(".timing a:eq(#{index})").html(text).data('value', time.time)
      if time.available
        $listEl.add($el).tooltip('hide')
        $listEl.add($el).find(".timing a:eq(#{index})").removeClass('na').tooltip('disable')
      else
        $listEl.add($el).find(".timing a:eq(#{index})").addClass('na')
          .tooltip({"title": "this time is unavailable, sorry", "placement": "top"})
      handleClick.call @


  removeCenter: =>
    console.log 'called removecenter'
    center = _.find(@markers, (marker) -> marker.type is "Client")
    center?.setMap(null)
    @markers = _.without(@markers, center)


  addCenter: (googleObjLatLng) =>
    unless _.find(@markers, (marker) -> marker.type is "Client")?.length > 0
      marker = new google.maps.Marker(
        position: googleObjLatLng
        title: "You're here!"
        icon: "/assets/customer.png"
        type: "Client"
      )
      marker.setMap(@map)
      @map.setCenter googleObjLatLng
      @markers.push marker

  addMarker: (obj) =>
    unless _.find(@markers, (marker) -> marker.placeId = obj.id)?.length
      marker = new google.maps.Marker(
        position: new google.maps.LatLng(obj.lat, obj.lng)
        title: "Hello from #{obj.id}!"
        placeId: obj.id
        html: "<a class='marker' href='##{obj.id}'>place</a>"
        icon: "/assets/pin.png"
      )
      @markers.push marker
      marker.setMap(@map)
      map = @map
      stub = $('#list_place_' + obj.id).clone(false)
      stub.find('.timing, .special_offers, [id^=favorites_small]').remove()
      newContent = $("<div class='fix-width-p'></div>").append(stub.find('h4, .rating, .place_features').detach())
      newContent.insertBefore(stub.find('.clear'))  
      boxText = document.createElement("div")
      boxText.className = "place popover-content"
      boxText.style.cssText = "border: 1px solid rgba(0,0,0,0.2); margin-top: 8px; padding: 10px; border-radius: 4px; background: white;"
      boxText.innerHTML = stub.html() + "<div class='arrow'></div>"
      myOptions =
        content: boxText
        disableAutoPan: false
        maxWidth: 0
        pixelOffset: new google.maps.Size(-175, -162)
        zIndex: 0
        boxStyle:
          opacity: 1
          width: "350px"
        closeBoxMargin: "10px 2px 2px 2px"
        closeBoxZIndex: 999
        closeBoxURL: "http://www.google.com/intl/en_us/mapfiles/close.gif"
        infoBoxClearance: new google.maps.Size(1, 1)
  #      map.setCenter(lat_lon)
        isHidden: false
        pane: "floatPane"
        enableEventPropagation: false
      
      google.maps.ib = ib = new InfoBox(myOptions)

      google.maps.event.addListener marker, "click", (e) ->
        google.maps.ib.close()
        ib.open map, this
        bindBlockListeners.call @, $(''), $(ib.content_)
        google.maps.ib = ib

      google.maps.event.addListener marker, "mouseover", ->
        selector = '#place_' + obj.id
        # console.log selector
        $(selector).addClass 'target'

      google.maps.event.addListener marker, "click", ->
        selector = '#' + obj.id
        # console.log selector
        # console.log $(selector).attr('href')
      setTimeout((->
        $('#place_' + obj.id).on 'mouseleave', (e) ->
          marker.setIcon '/assets/pin.png'
        $('#place_' + obj.id).on 'mouseenter', (e) ->
          marker.setIcon '/assets/pin_hover.png'
        $('#place_' + obj.id).on 'click', (e) ->
          google.maps.ib.close()
          ib.open map, marker
          google.maps.ib = ib
      ), 50)

      google.maps.event.addListener marker, "mouseout", ->
        selector = '#place_' + obj.id
        # console.log selector
        $(selector).removeClass 'target'


class FilterInput
  constructor: (needToShowMap = no)->
    self = @
    if needToShowMap
      blocksThatExist = $("#map_details_wrapper .place")
      page = @getPageNum()
      @places = new PlacesCollection(blocksThatExist, page) if $("#map_places").length > 0
    @give_more(true) if $(".more").length > 0
    @checkIfNeeded()
    @dirtyHack()
    @

  nextStep: =>
    @bindFilterChangeListener()
    @bindChangeListener()
    @give_more() if $(".more").length > 0


  bindFilterChangeListener: () ->
    self = @
    needToDisplay = _.reduce($("#refine input[type=checkbox]:checked"), ((memo,checkbox) ->
      type = $(checkbox).data('type')
      memo.push type unless _.contains memo, type
      memo
    ), [])

    for filter in needToDisplay
      @displayFilterType filter

    $('#refine input[type=checkbox]').on 'change.filterType', (e) =>
      type = $(e.target).data('type')
      if $(e.target).is(":checked")
        @displayFilterType(type) if $("##{type}_filter").length is 0
      else
        if $("#refine input[type=checkbox][data-type=#{type}]:checked").length is 0
          $("##{type}_filter")?.fadeOut("fast", () -> $(this).remove())
          if type is 'distance'
            self.places.removeCenter()


  displayFilterType: (filter_type) ->
    self = @
    if filter_type is 'distance'
      initialData = $('#map_places').data()
      center = new google.maps.LatLng(initialData.lat, initialData.lng)
      self.places.addCenter center

    if $("##{filter_type}_filter").length is 0
      filterBlock = "<span style='display: none;' id='#{filter_type}_filter'>#{filter_type}<b>×</b></span>"
      $('#filters').append(filterBlock)
      $("##{filter_type}_filter").fadeIn("fast").find('b').on 'click', (e) ->
        type = $(e.target).parent().fadeOut("fast", () -> $(this).remove()).attr('id').slice(0, -7)
        if type is 'distance'
          self.places.removeCenter()
        $("#refine input[type=checkbox][data-type=#{type}]:checked").click()





  dirtyHack: () ->
    querystring = window.location.search
    if gon? and gon.category
      gon["category"] = _.reduce gon["category"], (memo, num) ->
        memo + ',' + num
      gon["category"] = gon["category"] + ''
      needToCheck = _.extend({}, $.deparam(querystring.slice(1)), gon)
    else
      needToCheck = $.deparam querystring.slice(1)
    window.neededForCategory = {}
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
        $("#refine input[value='#{num}'][data-type='#{filter}']").one 'click', ->
          window.history.pushState '', null, "/search" + window.location.search

        parseInt(num) in alreadyThere[filter]
      ).length > 0
    for filter, flag of needed
      if flag
        $("a.more[data-type='#{filter}']").click()
        setTimeout(( ->
          self.getFilterseNeedToTriggerPaginate(needToCheck)
        ), 50)
    needed
    if _.values(needed).length > 1
      done = _.reduce(_.values(needed), (memo = true, val) ->
        memo = false if val
        memo
      )
    else
      done = not(_.values(needed)[0])
    if done
      @nextStep()


  getPageNum: () ->
    page = window.location.search.match( /page=\d*/)?[0].slice(5) || 1

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
        if window.language is 'en'
          regexpMatch = /reserve_time=(\d+\W+\w+\+(AM|PM))/
          regexpReplace = /reserve_time=(\d+\W+\w+\+(?:AM|PM))/
        else
         regexpMatch = /reserve_time=(\d+\W+\w+)/
         regexpReplace = /reserve_time=(\d+\W+\w+)/
      when 'number_of_people'
       regexpMatch = /number_of_people=(\d+)/
       regexpReplace = /number_of_people=\d+/
      when 'reserve_date'
       regexpMatch = /reserve_date=(\d+\%+\w+)/
       regexpReplace = /reserve_date=[\d+\%+\w+]*/
      when 'sort_by'
        regexpMatch = /sort_by=(\w+)/
        regexpReplace = /sort_by=[\w+]*/

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

    newUrl = (baseURL + '?' + newQuery).replace(/\/*\?+/, '?').replace("/??", '?')
    newQuery = newQuery.replace(/\?/g, '')
    window.history.pushState('',null, newUrl)
    if entity is 'page'
      pageTo = entityTo
      askAJAX.call(@, newQuery, @places, pageTo)
    if entity is 'reserve_time'
      pageTo = @getPageNum()
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
    $('#refine input[type=checkbox]').off 'change.addressBar'
    $('#refine input[type=checkbox]').on 'change.addressBar', (e) =>
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

      window.history.pushState('',null, newUrl)
      askAJAX.call(@, newQuery, @places, startPage)

    self = @
    $('input[name="reserve_date"]').data('Zebra_DatePicker').update(
      onSelect: (dateText) ->
        headlineText = $('#map_details > h3:first-child').html().replace(/(\d+\/?){3}(?=,)/, dateText)
        $('#map_details > h3:first-child').html headlineText
        window.filter.get 'reserve_date', dateText
    )
    $("select[name=reserve_time]").off 'change.filters'
    $("select[name=reserve_time]").on 'change.filters', ->
      need_suffex = false
      dateText = $('input[name="reserve_date"]').val()
      date = new Date()

      res = []
      res.push curr_date = if (day = date.getDate()) < 10 then '0' + day else day
      res.push curr_month = if (month = date.getMonth() + 1) < 10 then '0' + month else month  #Months are zero based
      res.push curr_year = date.getFullYear()
      time = $(this).val()
      need_suffex = true if time.match(/(AM|PM)/)
      dateToCompare = new Date("#{time} #{date.getMonth() + 1}/#{date.getDate()}/#{date.getFullYear()}")
      if (dateText == res.join('-') or dateText == res.join('/')) and (date >= dateToCompare)
        alert "The time has passed. Please select current time."
        # the last bit for 00, 30 part
        valid_date = new Date(date.setMinutes(date.getMinutes() + 90 - date.getMinutes() % 30))
        valid_hours = valid_date.getHours()
        valid_minutes = ["00", "30"][(valid_date.getMinutes() / 30)]
        if need_suffex
          suffex = (if (valid_hours >= 12) then " PM" else " AM")
          valid_hours = (if (valid_hours > 12) then valid_hours - 12 else valid_hours)
          valid_hours = (if (valid_hours is "00") then 12 else valid_hours)
          validHourString = valid_hours + ":" + valid_minutes + suffex
        else
          validHourString = valid_hours + ":" + valid_minutes

        console.log "validHourString #{validHourString}"
        $(this).val(validHourString)
      else
        validHourString = time
      headlineText = $('#map_details > h3:first-child').html().replace(/\d+\:\d+(?=\sfor\s)/, time)
      $('#map_details > h3:first-child').html headlineText
      # console.log "time = #{time}"
      window.filter.get 'reserve_time', validHourString


    $("select[name=number_of_people]").on 'change', ->
      number = $(this).val()
      headlineText = $('#map_details > h3:first-child').html().replace(/\d+(?=\speople)/, number)
      $('#map_details > h3:first-child').html headlineText
      window.filter.get 'number_of_people', number


    $("#sortby-list a").on 'click', (e) ->
      e.preventDefault()
      filterSelected = $(e.target)
      if filterSelected.text() != $("#sortby").text()
        $("#sortby").text(filterSelected.text())
        text =  filterSelected.attr('href')
        window.filter.get "sort_by", text
        window.filter.get "page", 1


  askAJAX = (serializedData, placesObj, page) =>
    $.ajaxSetup
#      cache: false
      dataType: "json",
      url: window.location.pathname || "/search",
      type: "GET"
      error: (xhr, error) ->
        $.noop()
#         console.log xhr, error
      success: (json) ->
         placesObj.useNewData(json, page)
      beforeSend: () ->
        $.noop()
#       sending ajax request, can do animation here'
      complete: () ->
        $.noop()
#       ajax request completed, can remove animation here'

    $.ajax({ data: serializedData });

  give_more: (no_binding = false) =>
    @more_template = Handlebars.compile($("#more_template").html())
    self = @
    $("a.more").off 'click.more'
    $("a.more").one 'click.more', (e) ->
      e.preventDefault()
      $el = $(this)
      type = $el.data('type')
      if type
        $.getJSON '/search/get_more',{type: type}, (data) => parse_more_objects.call(self, data, $el, type, no_binding)

  #private methods
  parse_more_objects = (data, $el, type, no_binding) ->
    _.each data, (obj) =>
      _.extend obj, {type: type}
      $el.prev().prev().after(@more_template(obj))
      @checkIfNeeded()
      unless no_binding
        @bindChangeListener()
        @bindFilterChangeListener()
    $el.hide()

$ ->
  if $("[id^='list_place'], [id^='place_']").length > 0
    $("[id^='list_place'], [id^='place_']").find('.timing .na').tooltip({"title": "this time is unavailable, sorry", "placement": "top"})
  if $('#refine').length isnt 0
    window.filter = new FilterInput yes

  if $('.paginate').length isnt 0
    total = parseInt($('#total').html())
    new Pagination( total )
  handleClick()
  $('body').on 'ajaxStart', ->
    loader   = $("#ajax_fixed_loader_template").html()
    $('body').append loader if $("#ajax_loader_overlay").length is 0
  $('body').on 'ajaxStop', ->
    $("#ajax_loader_overlay").fadeOut ->
      $(@).remove()

handleClick = ()->
  $('.timing a').off 'click.reserve', (e) ->
  $('.timing a').on 'click.reserve', (e) ->
    e.preventDefault()
    return false if $(e.target).hasClass('na')
    querystring = window.location.search
    params = $.deparam querystring.slice(1)
    defaults =
      "reserve_date": $("input[name='reserve_date']").val()
      "number_of_people": $("select[name=number_of_people]").val()

    result = _.extend {}, defaults, params
    result["reserve_date"] = result["reserve_date"].replace(/\//g,'-')
    language = $('#language .active').attr('id')
    id = $('#place').data('id') || $(e.target).parents('.place').data('id')
    time = $(e.target).data('value').replace(/\s/, '')
    newLink = "/#{language}/new_reservation/#{result["reserve_date"]},#{id},h=#{time.split(':')[0]}&m=#{time.split(':')[1]},#{result["number_of_people"]}"
    window.location.replace newLink