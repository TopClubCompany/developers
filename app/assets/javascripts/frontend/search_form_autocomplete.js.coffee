$ ->
  options =
    serviceUrl: '/autocomplete'
    minChars: 1
    delimiter: /(,|;)\s*/
    # maxHeight:400,
    width:268
    zIndex: 10
    deferRequestBy: 0
    # params: { q:'Yes' }, //aditional parameters
    # noCache: false, //default is false, set to true to disable caching
    onSelect: (value, data) ->
#      $('#search_form').find('form:eq(0)').trigger("submit")



  $("#title_or_location").oautocomplete(options)