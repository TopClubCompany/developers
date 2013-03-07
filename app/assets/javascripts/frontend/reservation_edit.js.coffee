updateSelect = ->
  # Assuming it's -> "/en/new_reservation/07-03-2013,20,h=15&m=00,2"
  # Hardcode is bad, but it's temporary
  id = $("#edit_reservation").data('placeId')
  $.ajax
    url: "/#{window.language}/reservations/available_time?place_id=#{id}&reserve_date=#{$("#reservation_date").val()}"
    success: (data) ->
      time_was = $("select[name='reserve_time']").find("option[selected='selected']").text()
      $("select[name='reserve_time']").find('option').not("[selected='selected']").remove()
      for time in data.times
        if time isnt time_was
          $("select[name='reserve_time']").append("<option value='#{time}'>#{time}</option>") 

initDatePicker = ->
  offset = [-180, 0]  
  $datepicker = $("#reservation_date")
  $datepicker.Zebra_DatePicker(
    "offset": offset
    "format": 'd/m/Y'
    'direction': true
    'zIndex': 8
    'always_show_clear': false
    'days': I18n.translations[window.language].admin_js.day_names
    'days_abbr': I18n.translations[window.language].admin_js.abbr_day_names
    'months': I18n.translations[window.language].admin_js.month
    onSelect: (dateText) ->
      updateSelect()
  )

  magic_number = $datepicker.offset().top + $datepicker.height() + 12
  $('.Zebra_DatePicker').css('top', magic_number)

$ ->
  window.language ||= $('#language .active').attr('id')
  if $("#edit_reservation").length > 0
    initDatePicker()
