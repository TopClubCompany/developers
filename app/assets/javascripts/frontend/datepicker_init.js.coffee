$(document).ready ->
  $datepicker = $('input[name="reserve_date"]').css('zIndex', '2')
  if $datepicker.hasClass('dateFormatNeeded').length > 0
    $datepicker.datepicker({ "dateFormat": 'dd/mm/yy'})
  else
    $datepicker.datepicker()
