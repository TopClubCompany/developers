$(document).ready ->
  $datepicker = $('input[name="reserve_date"]')
  if $datepicker.hasClass('dateFormatNeeded').length > 0
    $datepicker.datepicker({ "dateFormat": 'dd/mm/yy'})
  else
    $datepicker.datepicker()
