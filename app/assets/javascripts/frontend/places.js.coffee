$ ->
  $('.add_to_favorites').click ->
    $(this).toggleClass 'i_like_this_place'

  $("ul.carousel_bullets li").click ->
    img_element = $(".place_img img")
    link_for_fancy = $("a.fancybox")
    $("ul.carousel_bullets li").removeClass("current")
    $(this).addClass("current")
    img_element.attr('src', $(this).data('small_image_src'))
    link_for_fancy.attr('href', $(this).data('big_image_src'))

  $(".popoverable").popover(html: true)

  $(".fancybox").fancybox()

  $("a#write_review").click (e) ->
    e.preventDefault()
#    $("#review_text").focus()
    $('html,body').animate
      'scrollTop': $('#review_text').offset().top - 35
    ,
      "duration": 1000
      "complete": ->
        $("#review_text").focus()

  $("#review_text").on 'blur', (e) ->
    if $(@).val().length > 0
      $(@).addClass 'not_empty'
    else
      $(@).removeClass 'not_empty'

  if $("#promo_tabs").length > 0
    hash = location.hash.replace(/#?(\w+)/, "$1")
    $('.tab_content').hide().eq(0).show()
    available_hashes = $('.tab_content').map () ->
	    $(this).attr('id')
    if hash in available_hashes
      showHash.call @, hash

  if $('#promo_tabs').length > 0
	  $('#promo_tabs a').click (e)->
      e.preventDefault();
      showHash.call @, $(this).attr('href'), yes

	showHash = (hashName, stripNeed = no) ->
    hashName = hashName.slice(1) if stripNeed
    history.pushState {}, "", "##{hashName}"
    $("a[href=##{hashName}]").parent().addClass('active').siblings().removeClass('active')
    $("##{hashName}").show().siblings('.tab_content').hide()

  setTimeout((->
    if $('#map').length > 0
      initialData = $('#map').data()
      mapOptions =
        center: new google.maps.LatLng(initialData.lat, initialData.lng),
        zoom: 13,
        minZoom: 9,
        mapTypeId: google.maps.MapTypeId.ROADMAP
      map = new google.maps.Map(document.getElementById("map"), mapOptions)
      marker = new google.maps.Marker(
        position: new google.maps.LatLng(initialData.lat, initialData.lng)
        title: "Hello from here!"
      )
      marker.setMap(map)
      google.maps.event.trigger($("#map")[0], 'resize');
  ), 1000)

