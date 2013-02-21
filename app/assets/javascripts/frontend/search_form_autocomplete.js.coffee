$ ->
  options =
    serviceUrl: '/autocomplete'
    minChars: 1
    delimiter: /(,|;)\s*/
    maxHeight: 230
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
$ ->
  divAutoComplete = $('#tol_c div:first').hide()
  $('#tol_c #title_or_location').keyup ->
    val = $(this).val()
    if(val || val != '')
      divAutoComplete.show()
    else
      divAutoComplete.hide()