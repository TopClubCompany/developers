$ ->
  options =
    serviceUrl: '/autocomplete'
    minChars: 1
    delimiter: /(,|;)\s*/
    # maxHeight:400,
    # width:
    zIndex: 10
    deferRequestBy: 0
    wrapper: '#tol_c'
    # appendTo: '#tol_c'
    # params: { q:'Yes' }, //aditional parameters
    # noCache: false, //default is false, set to true to disable caching
    onSelect: (value, data) ->
#      $('#search_form').find('form:eq(0)').trigger("submit")



  $("#title_or_location").oautocomplete(options)