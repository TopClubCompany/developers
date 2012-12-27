$ ->
  $('.add_to_favorites').click ->
    $(this).toggleClass 'i_like_this_place'

  if $("#promo_tabs").length > 0
    hash = location.hash.replace(/#?(\w+)/, "$1")
    $(".tab_content").hide()
    available_hashes = $('.tab_content').map () -> 
	    $(this).attr('id')
    if hash in available_hashes
      showHash.call @, hash
    else
      showHash.call @, available_hashes[0]

  if $('#promo_tabs').length > 0
	  $('#promo_tabs a').click (e)->
      e.preventDefault();
      showHash.call @, $(this).attr('href'), yes

	showHash = (hashName, stripNeed = no) ->
    hashName = hashName.slice(1) if stripNeed
    history.pushState {}, "", "##{hashName}"
    $("a[href=##{hashName}]").parent().addClass('active').siblings().removeClass('active')
    $("##{hashName}").show().siblings('.tab_content').hide()  
 
  console.log 'lold', $('#map').length > 0
  setTimeout((->
    if $('#map').length > 0
      console.log 'lold'
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
  