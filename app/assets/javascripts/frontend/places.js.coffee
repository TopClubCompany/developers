$ ->
  #handle reviews marks
  $(".set_rating a.rate").on
    'mouseenter': (e) ->
      [main_element, text_mark, stars_bar] = initStarElements.call @
      unless main_element.data('old_mark')
        main_element.data('old_mark', text_mark.text())
      $(".set_rating .bar").css("width", "#{$(this).data('mark') * 20}%")
      text_mark.text($(this).data('mark')).css('color', 'gray')

    'click': (e) ->
      e.preventDefault()
      [main_element, text_mark, stars_bar] = initStarElements.call @
      main_element.data('old_mark', $(this).data('mark'))
      stars_bar.css("left", "#{main_element.data('old_mark') * 20}%")
      $(main_element.find(".review_mark_value")).val($(this).data('mark'))
      text_mark.removeAttr('style')
      set_overall_mark.call @

  $(".set_rating").on
    'mouseleave': (e) ->
      [main_element, text_mark, stars_bar] = initStarElements.call @
      stars_bar.css("left", "#{main_element.data('old_mark') * 20}%")
      text_mark.text(main_element.data('old_mark')).removeAttr('style')

  initStarElements = ->
    main_element = $(this).closest(".criteria")
    text_mark = main_element.find(".p")
    stars_bar = main_element.find(".stars_bar")
    [main_element, text_mark, stars_bar]

  #computing overall mark
  set_overall_mark = () ->
    sum = 0
    $('.marks .criteria').each ->
      console.log $(this).data('old_mark')
      value = parseInt($(this).data('old_mark')) || 1
      sum += value
    quantity = $('.marks .criteria').length
    overall_mark_value = sum / quantity
    overall_mark_css_value = "#{overall_mark_value * 20}%"
    overall_mark_el = $(".overall_mark .stars_bar")
    console.log overall_mark_el[0]
    overall_mark_el.css('left', overall_mark_css_value)
    overall_mark_el.closest('.span3').find(".p").text(overall_mark_value)

  #handle place description
  $("a.desc_expand").click (e) ->
    e.preventDefault();
    $(".place_desc .full_description").toggleClass("active_desc")
    $(".place_desc .short_description").toggleClass("active_desc")
    text = (if $(this).hasClass("roll_up") then $(this).data('expand') else $(this).data('rollup'))
    $(this).toggleClass("roll_up").text(text)

  $('.add_to_favorites').click ->
    $(this).toggleClass 'i_like_this_place'
    if $(this).hasClass('i_like_this_place')
      $(this).parent().css('display', 'block')
    else
      $(this).parent().removeAttr('style')
    $.post("/set_unset_favorite_place/#{$(this).data('id')}")

  movingItself = setInterval (->
    if $("ul.carousel_bullets li.current").next().length > 0
      $("ul.carousel_bullets li.current").next().click()
    else
      $("ul.carousel_bullets li").first().click()
  ), 5000

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

  # promo tabs toggler and history pushState
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

  # google map handler
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

