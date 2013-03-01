$ ->
  $datepicker = $('input[name="reserve_date"]')
  if $datepicker.length > 0
    offset = [-180, 0]
    window.language = $('#language .active').attr('id')
    $datepicker.Zebra_DatePicker(
      "offset": offset
      "format": 'd/m/Y'
      'direction': true
      'zIndex': 8
      'always_show_clear': false
      'days': I18n.translations[window.language].admin_js.day
      'days_abbr': I18n.translations[window.language].admin_js.abbr_day_names
      'months': I18n.translations[window.language].admin_js.month
    )

    magic_number = $datepicker.offset().top + $datepicker.height() + 20
    $('.Zebra_DatePicker').css('top', magic_number)

