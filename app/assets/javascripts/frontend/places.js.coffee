load_places = (data) ->
  $("#more_places_link").remove()
  $("#new_loader").before data
  $("#more_places_link").hide()
  $("#new_loader").hide()

disable_user_rating = (data) ->
  $('#user_rating').raty(
    readOnly : true,
    score    : data
  )
  $('#user_rating').addClass "half_opacity"

@Styx.Initializers.Places =

  initialize: -> $ ->
    $(".tabs_module li:first").next().toggleClass "active"
    $(".tabs_module li.active").next().css "border-left", "white 1px solid"

    $("ul.category").children(".element").each (index, obj) ->
      $(obj).hide() if index > 3

    $("span.more_category_btn").live "click", ->
      $("ul.category").children(".element").each (index, obj) ->
        $(obj).show() if index > 3
        $("span.more_category_btn").parent().remove()

    $("ul.kitchen").children(".element").each (index, obj) ->
      $(obj).hide() if index > 3

    $("span.more_kitchen_btn").live "click", ->
      $("ul.kitchen").children(".element").each (index, obj) ->
        $(obj).show() if index > 3
        $("span.more_kitchen_btn").parent().remove()

    $("span.sort_btn").live "click", ->
      $(".buttom_second").removeClass "active"
      $(this).parents(".buttom_second").addClass "active"

    $(".collection_filtres li").live "click", ->
      $(this).toggleClass "active"
      $(this).parents(".buttom_second").removeClass "active"

    $(".tabs_module li").live "click", ->
      $(".tabs_module li.active").next().css "border-left", "#ccc 1px solid"
      $(".tabs_module li").removeClass "active"
      $(this).addClass "active"
      $(".tabs_module li.active").next().css "border-left", "white 1px solid"
      $(".tabs_module>div").hide()
      block = $(".tabs_module li.active").attr("block")
      $("." + block).show()

    $('form#filter').live "ajax:success", (obj, data, status, xhr) ->
      $(".show_result.cf").remove()
      load_places data

  index: (data) -> $ ->
    center_position = new google.maps.LatLng(data['point'].split(',')[0], data['point'].split(',')[1] )
    map = new google.maps.Map(document.getElementById("right_map"), center: center_position, zoom: 14, mapTypeId: "roadmap", disableDefaultUI: true)
    center_marker = new google.maps.Marker( position: center_position, map: map )

    if data['places'].length > 0
      latlngbounds = new google.maps.LatLngBounds()
      places = for index, place of data['places']
        lat_lng = place[0]
        icon = place[1]
        marker = new google.maps.Marker(
          position: new google.maps.LatLng( lat_lng.split(',')[0], lat_lng.split(',')[1] ),
          title: icon
        )
        marker.setMap map
        latlngbounds.extend marker.getPosition()

      map.setCenter( latlngbounds.getCenter( ), map.fitBounds(latlngbounds) )

    google.maps.event.addDomListener(window, 'load', map);

    $('.filter_val').live 'change', ->
      $('form#filter').submit()

    $("#new_loader").hide()
    $("#more_places_link").hide()

    opts = { offset: '100%' }

    $(".footer").waypoint(
      ((event, direction) ->
        if direction is "down" and $("#more_places_link").length
          $(".footer").waypoint('remove')
          $("#new_loader").show()
          $.get(
            $("#more_places_link").attr("href"),
          (data) ->
            load_places data
            $(".footer").waypoint(opts)
          )
      ),
      opts
    )

  show: (data) -> $ ->
    position = new google.maps.LatLng(data['point'].split(',')[0], data['point'].split(',')[1] )
    map = new google.maps.Map(document.getElementById("map"), center: position, zoom: 14, mapTypeId: "roadmap", disableDefaultUI: true)
    marker = new google.maps.Marker(
      position: position
      map: map
    )
    google.maps.event.addDomListener(window, 'load', map);

    $('#map.map').resizable(
      maxWidth: 620,
      minWidth: 620,
      minHeight: 145
    )

    addthis.button("#at_button", { ui_click:true }, {})

    $('#submit_review').live 'click', ->
      $('form.edit_place').submit()
      return false

    $('a.add_to').live "ajax:success", (obj, data, status, xhr) ->
      $('#'+data[0]).html(data[1])
      $(this).removeAttr "href"
      $(this).removeAttr "data-remote"
      $(this).removeAttr "data-method"
      $(this).parent().parent().addClass "half_opacity"

    $('#rating').raty(
      readOnly : true,
      score    : data['rating']
    )

    if data['can_be_rated']
      $('#user_rating').raty(
        score: ->
          $(this).attr('data-rating')
        click: (rating, e)->
          $.post(
            data['rating_url'], "place":{ "rating": rating },
            (result) ->
              $('#rating').raty(
                readOnly : true,
                score    : result
              )
              disable_user_rating result
          )
      )
    else
      disable_user_rating data['rating']

    unless data['can_be_favorite']
      $('.act_btn.favorits .middle a').removeAttr "href"
      $('.act_btn.favorits .middle a').removeAttr "data-remote"
      $('.act_btn.favorits .middle a').removeAttr "data-method"
      $('.act_btn.favorits').addClass "half_opacity"

    unless data['can_be_planned']
      $('.act_btn.add_plans .middle a').removeAttr "href"
      $('.act_btn.add_plans .middle a').removeAttr "data-remote"
      $('.act_btn.add_plans .middle a').removeAttr "data-method"
      $('.act_btn.add_plans').addClass "half_opacity"

    unless data['can_be_visited']
      $('.act_btn.check_in .middle a').removeAttr "href"
      $('.act_btn.check_in .middle a').removeAttr "data-remote"
      $('.act_btn.check_in .middle a').removeAttr "data-method"
      $('.act_btn.check_in').addClass "half_opacity"

