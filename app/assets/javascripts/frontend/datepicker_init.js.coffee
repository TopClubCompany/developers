$ ->
  $datepicker = $('input[name="reserve_date"]')
  if $datepicker.length > 0
    $datepicker.css('zIndex', '2')
    if $datepicker.hasClass('dateFormatNeeded')
      $.datepicker.setDefaults
        dateFormat: 'dd/mm/yy'
    $datepicker.datepicker()
 


      
