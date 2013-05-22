class ChooseCityMap

  constructor: ->
    if window.gon && window.gon.cities
      @create_map()
      @create_marker()

  create_map: ->
    # Создаем карту
    @map = new google.maps.Map(document.getElementById('cities_map'), {
      zoom: 6,
      center: new google.maps.LatLng(48.835797, 36.474609),
      disableDefaultUI: true,
      zoomControl: false,
      mapTypeId: google.maps.MapTypeId.ROADMAP
    })

  create_marker: ->
    # Создаем и размещаем маркеры на карте

    for city in window.gon.cities
      if city.latitude && city.longitude
        google.maps.event.addListener(new google.maps.Marker({
          position: new google.maps.LatLng(city.latitude, city.longitude),
          icon: '/assets/pin.png',
          title: city.title,
          slug: city.slug,
          map: @map
        }), 'click', ->
          window.location.href = url = "/update_city/#{@slug}"
        )

$ ->
  new ChooseCityMap()