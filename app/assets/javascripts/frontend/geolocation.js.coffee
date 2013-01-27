class GeoLocation
  constructor: ->
    if navigator.geolocation
      navigator.geolocation.getCurrentPosition(@setLocation)
    else
      console.log 'browser doesnt support geolocating'
  setLocation: (@position) ->
    coords = @position.coords
    data = "#{coords.latitude}, #{coords.longitude}"
    $.cookie('current_point', data, { expires: 7 })
$ ->
  new GeoLocation()