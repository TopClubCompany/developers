$ ->
  # if $("#title_or_location").length > 0
    # $("#title_or_location").on 'keyup', ->
      # if $(this).val().length >= 3
        # $.getJSON "autocomplete?q=#{$(this).val()}", (data) ->  
          # possibilities = $.map data.suggestions, (possibility) ->
            # possibility
          # console.log possibilities
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
      console.log 'not main page'
      _.extend options, {width: 167}
      console.log options
    $("#title_or_location").oautocomplete(options)
        




