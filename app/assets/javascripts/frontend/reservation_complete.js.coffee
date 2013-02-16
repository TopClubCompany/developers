months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November"
, "December"]
days = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]

doMagic = () ->
  $("#complete .complete_edit").off 'click'
  $("#complete .complete_edit").on 'click', =>
    $("#complete").hide().after($("#search_form").show())
    initDatepicker()
  $("#search_form input[type='submit']").off 'submit click'
  $("#search_form input[type='submit']").on 'submit click', (e) =>
    console.log 'binded submit'
    e.preventDefault()
    fromDate = $("input[name='reserve_date']").val().split('/')
    fromTime = $("select[name='reserve_time']").val().split(':')
    date = new Date(fromDate[2], fromDate[1] - 1, fromDate[0], fromTime[0], fromTime[1])
    timeString = date.toLocaleTimeString()
    timeString = timeString.slice(0, -3) if timeString.match /(\d{1,2}\:){2}\d{2}/

    person_num = $("#search_form select[name='number_of_people']").val()
    HTMLToSet = $('#complete > h1')[0].outerHTML + $('#complete > strong')[0].outerHTML +
    " #{days[date.getDay()]}, #{months[date.getMonth()]} #{date.getDate()}, #{date.getFullYear()} at #{timeString} for #{person_num}" + $('#complete > .complete_edit')[0].outerHTML
    $('#complete').html(HTMLToSet)
    $('#reservation_time').val(date.toJSON())
    $('#reservation_persons').val(person_num)
    $("#search_form, #complete").toggle()
    doMagic()

initDatepicker = ->
  $datepicker = $('input[name="reserve_date"]')
  if $datepicker.length > 0
    offset = [-180, 0]
    $datepicker.Zebra_DatePicker(
      "offset": offset
      "format": 'd/m/Y'
      'direction': true
      'zIndex': 8
    )
    magic_number = $datepicker.offset().top + $datepicker.height() + 20
    $('.Zebra_DatePicker').css('top', magic_number)

$ ->
  if $("#complete .complete_edit").length
    doMagic()




