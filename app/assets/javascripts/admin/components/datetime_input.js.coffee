$ ->
  window.setInputDateTime = (field) ->
    date = $("##{field}_date").val()
    time = $("##{field}_time").val()
    $('#' + field).val("#{date} #{time}")

  window.initPickers = ->
    $('input.datepicker').datepicker({format: 'dd.mm.yyyy', language: 'ru'}).on 'changeDate', (e) ->
      setInputDateTime($(e.target).data('target'))
    $('input.timepicker').timepicker({showMeridian: false}).bind 'hidden', (e) ->
      setInputDateTime($(e.target).data('target'))

  initPickers()

  $('.simple_form').bind "nested:fieldAdded", =>
    initPickers()
    initChosen()