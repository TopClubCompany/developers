$ ->
  window.language ||= $('#language .active').attr('id')

  if $('#search_form.place_timing').length
    if document.referrer
      $('#search_form.place_timing a.back').show().on 'click', (e) ->
        e.preventDefault()
        window.location.href = document.referrer


  #temp handle noise mark
  $(".set_noise a.set").click (e) ->
    e.preventDefault()
    id = $(this).attr('id')
    noise_level_el = $(".noise.noise_big .noise_level")
    noise_label_el = $(".noise.noise_big .p")
    noise_input_el = $(".noise.noise_big").closest('.criteria').find('input.review_mark_value')
    noise_level_el.removeClass('noise_1 noise_2 noise_3 noise_4 noise_5')
    noise_level_el.addClass(id)
    noise_label_el.text(id[id.length - 1])
    noise_input_el.val(id[id.length - 1])
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
    $('.marks .criteria.included').each ->
      value = parseInt($(this).data('old_mark')) || 1
      sum += value
    quantity = $('.marks .criteria.included').length
    overall_mark_value = sum / quantity
    overall_mark_css_value = "#{overall_mark_value * 20}%"
    overall_mark_el = $(".overall_mark .stars_bar")
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
    if gon?.current_user
      $(this).toggleClass 'i_like_this_place'
      if $(this).hasClass('i_like_this_place')
        message = 'add'
        $(this).parent().css('display', 'block')
      else
        message = 'remove'
        $(this).parent().removeAttr('style')
      text = I18n.translations["#{window.language}"].admin_js.like["#{message}"]
      $.ajax
        type: "POST"
        url: "/set_unset_favorite_place/#{$(this).data('id')}"
        success: (data) ->
          $('.top-right').notify({"message": {"text": text}}).show()
      
    else
      window.location.replace "/users/sign_in"

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
  array = []
  $('.carousel_bullets li').each (index, bullet) ->
    array.push
      href: $(bullet).data('big_image_src')
      title: "#{index + 1}ая фотография"

  $('.fancybox').on 'click', (e) ->
    e.preventDefault()
    $.fancybox(array, {})

  $("a#write_review").click (e) ->
    e.preventDefault()
    $('html,body').animate
      'scrollTop': $('#review_form').offset().top - 35
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

  # menu popup
  $("a.show_popup.menu").fancybox({'padding':0})
  $("a.show_popup.share").fancybox({'padding':0, 'scrolling':no, 'autoScale':false})
  $("a.show_popup.menu").click (e) ->
    e.preventDefault();
    $(this).fancybox()

  # share popup
  $("a.show_popup.share").click (e) ->
    e.preventDefault();
    soc_id = $(this).attr('id')
    $("ul.share_selector li").removeClass('active')
    $("ul.share_selector li#"+ soc_id).addClass('active')
    tw_button = $(".tw_button")
    fake_submit = $("#fake_for_twitter")
    standart_share_bt = $(".standart_share_button")
    if soc_id == 'tw'
      tw_button.css('display', 'inline-block')
      fake_submit.css('display', 'inline-block')
      standart_share_bt.css('display', 'none')
    else
      tw_button.css('display', 'none')
      fake_submit.css('display', 'none')
      standart_share_bt.css('display', 'inline-block')
    $(this).fancybox()
    share_text_input = $("#share_text_input")
    share_text_input.val(share_text_input.data('description'))
    $("#share_text_input").keyup()

  # click on social networks buttons in share popup
  $("ul.share_selector li").live 'click', ->
    $(this).toggleClass('active')
    if $(this).attr('id') == 'tw'
      tw_button = $(".tw_button")
      standart_share_bt = $(".standart_share_button")
      fake_submit = $("#fake_for_twitter")
      if $(this).hasClass('active')
        tw_button.css('display', 'inline-block')
        fake_submit.css('display', 'inline-block')
        standart_share_bt.css('display', 'none')
      else
        tw_button.css('display', 'none')
        fake_submit.css('display', 'none')
        standart_share_bt.css('display', 'inline-block')

#  tw_case=(id) ->


  #twitter share
  init_twitter = ->
    not ((d, s, id) ->
      fjs = undefined
      js = undefined
      js = undefined
      fjs = d.getElementsByTagName(s)[0]
      unless d.getElementById(id)
        js = d.createElement(s)
        js.id = id
        fjs.parentNode.insertBefore js, fjs
      )(document, "script", "twitter-wjs")
    window.twttr.events.bind "click", (event) ->
      check_what_share_open()
      $.fancybox.close()

  check_what_share_open =() ->
    active_soc_el = $("ul.share_selector li.active")
    active_soc_el.each ->
      if $(this).attr('id') == 'fb'
        $("a.share.facebook").click()
      if $(this).attr('id') == 'vk'
        $('#vk_share_button').find('a').first().click()

  #vk share
  init_vk =(data) ->
    vk_skin = $("#vk_share_button")
    vk_skin.html VK.Share.button(
      url: document.URL
      title: data.title
      description: data.description
      image: data.picture
    ,
      type: data.link
    )


  fb_link = $("a.share.facebook")
  if fb_link.length
    FB.init
      appId: fb_link.data('app-id')

  #facebook share handle
  init_fb =(data) ->
    fb_link = $("a.share.facebook")
    fb_link.unbind('click')
    fb_link.bind 'click', ->
      FB.ui
        method: "feed"
        name: data.title
        link: data.link
        picture: data.picture
        caption: " "
        description: data.description

  $(".standart_share_button").click ->
    check_what_share_open()
    $.fancybox.close()

  tweet_dynamyc_text_magick =(data) ->
    tweet_button = $(".twitter-share-button")
    tweet_main_div = $(".tw_button#custom-tweet-button")
    tweet_button.remove()
    $("<a/>",
      "class": 'twitter-share-button'
      "data-lang": 'en'
      "href": 'https://twitter.com/share'
      "data-url": data.link
      "data-text": data.description
      "data-count": 'none'
    ).appendTo(tweet_main_div)
    twttr.widgets.load();
  init_twitter()

  $("#share_text_input").keyup ->
    data = $(this).data()
    data_for_soc = $.extend({}, data)
    data_for_soc.description = $(this).val()
    tweet_dynamyc_text_magick(data_for_soc)
    init_vk(data_for_soc)
    init_fb(data_for_soc)

#  $("#custom-tweet-button").hover ->
#    $("#fake_for_twitter").mouseover()
#    console.log $("#fake_for_twitter")

  $('#custom-tweet-button').on 'mouseenter', ->
    $('#fake_for_twitter').mouseenter()
  $('#custom-tweet-button').on 'mouseleave', ->
    $('#fake_for_twitter').mouseleave()
  prepare_tweet_button =() ->
    button = $("#custom-tweet-button")
    fake = $("#fake_for_twitter")
    button.attr('width', fake.attr('width')).attr('height', '26px')

  prepare_tweet_button()

  $('.review_vote a').on 'click', (e) ->
    e.preventDefault()
    data = $(@).data()
    if gon?.current_user
      if data.id isnt 'can not vote'
        $.ajax
          type: 'POST'
          url: "/reviews/vote"
          data: 
            "id": data.id
            "useful": data.useful
          success: (response) =>
            if response.success              
              num = parseInt($(@).find('strong').text())
              $(@).find('strong').text(num + 1)
            else
              # $(@).attr 'title', I18n.translations[window.language].admin_js.vote_twice
              $(@).attr 'title', response.error
              $(@).tipsy({ gravity: 's', fadeOut: 1500 }).tipsy('show')
              setTimeout((=> 
                $(@).tipsy 'hide'
              ), 3000)              
          error: (xhr, err) ->
            $(@).attr 'title', err
            $(@).tipsy({ gravity: 's', fadeOut: 1500 }).tipsy('show')
            setTimeout((=> 
              $(@).tipsy 'hide'
            ), 3000)
      else
        $(@).attr 'title', I18n.translations[window.language].admin_js.own_review
        $(@).tipsy { gravity: 's', fadeOut: 3000 }
        $(@).tipsy 'show'
        setTimeout((=> 
          $(@).tipsy 'hide'
        ), 3000)
    else
      window.location.replace "/users/sign_in"