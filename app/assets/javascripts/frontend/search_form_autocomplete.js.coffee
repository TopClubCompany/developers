$ ->
  options = 
    serviceUrl: '/autocomplete'
    minChars: 1
    delimiter: /(,|;)\s*/
    # maxHeight:400,
    width:270,
    zIndex: 9999
    deferRequestBy: 0
    # params: { q:'Yes' }, //aditional parameters
    # noCache: false, //default is false, set to true to disable caching
    onSelect: (value, data) ->
      console.log ('You selected: ' + value + ', ' + data)

    
  if $("#title_or_location").length > 0
    if $("#title_or_location").parent().is('.shorten')
      _.extend options, {width: 167}
    $("#title_or_location").oautocomplete(options)
        
$("#search_form form").submit ->
  result = $("form").children(":input").filter () ->
    $(this).val().replace(/\s/,'').length is 0
  result.each (i, el) ->
    $(el).attr 'name', ''
  true # ensure form still submits  



