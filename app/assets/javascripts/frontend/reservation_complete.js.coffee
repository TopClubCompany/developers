
doMagic = () ->
  $("#complete .complete_edit").off 'click'
  $("#complete .complete_edit").on 'click', =>
    $("#complete").hide().after($("#search_form").show())
    updateSelect()
    initDatepicker()
  $("#search_form input[type='submit']").off 'submit click'
  $("#search_form input[type='submit']").on 'submit click', (e) =>
    e.preventDefault()
    fromDate = $("input[name='reserve_date']").val().split('/')
    timeString = $("select[name='reserve_time']").val()
    date = new Date(fromDate[2], fromDate[1] - 1, fromDate[0], 0, 0)
    person_num = $("#search_form select[name='number_of_people']").val()
    atText = I18n.translations[window.language].admin_js.at
    forText = I18n.translations[window.language].admin_js.for
    person = I18n.translations[window.language].admin_js.person
    people = I18n.translations[window.language].admin_js.people
    HTMLToSet = $('#complete > h1')[0].outerHTML + $('#complete > strong')[0].outerHTML +
    " #{days[date.getDay()]}, #{months[date.getMonth()]} #{date.getDate()}, #{date.getFullYear()} #{atText} #{timeString} #{forText} #{person_num} #{if person_num is '1' then person else people}" + 
    $('#complete > .complete_edit')[0].outerHTML
    $('#complete').html(HTMLToSet)
    $('#reservation_time').val(date.toJSON())
    $('#reservation_persons').val(person_num)
    $("#search_form, #complete").toggle()
    doMagic()
updateSelect = ->
  if (path = window.location.pathname).match /new_reservation/
    # Assuming it's -> "/en/new_reservation/07-03-2013,20,h=15&m=00,2"
    # Hardcode is bad, but it's temporary
    id = (array = path.split('/'))[array.length - 1].split(',')[1]
    $.ajax
      url: "/#{window.language}/reservations/available_time?place_id=#{id}&reserve_date=#{$("input[name='reserve_date']").val()}"
      success: (data) ->
        time_was = $("select[name='reserve_time']").find("option[selected='selected']").text()
        $("select[name='reserve_time']").find('option').not("[selected='selected']").remove()
        for time in data.times
          if time isnt time_was
            $("select[name='reserve_time']").append("<option value='#{time}'>#{time}</option>") 


initDatepicker = ->
  $datepicker = $('input[name="reserve_date"]')
  if $datepicker.length > 0
    offset = [-180, 0]
    $datepicker.Zebra_DatePicker(
      "offset": offset
      "format": 'd/m/Y'
      'direction': true
      'zIndex': 8
      onSelect: (dateText) ->
        updateSelect()
    )
    magic_number = $datepicker.offset().top + $datepicker.height() + 20
    $('.Zebra_DatePicker').css('top', magic_number)

$ ->
  window.language = $('#language .active').attr('id')
  window.months = I18n.translations[window.language].admin_js.month
  window.days = I18n.translations[window.language].admin_js.day_names.map (word) -> word.charAt(0).toUpperCase() + word.slice(1);

  if $("#complete .complete_edit").length
    doMagic()




