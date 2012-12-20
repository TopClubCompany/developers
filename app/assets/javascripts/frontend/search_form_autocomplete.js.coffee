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
    # width:300,
    zIndex: 9999
    deferRequestBy: 0
    # params: { q:'Yes' }, //aditional parameters
    # noCache: false, //default is false, set to true to disable caching
    onSelect: (value, data) ->
      console.log ('You selected: ' + value + ', ' + data)

    
  
  $("#title_or_location").oautocomplete(options)
    
        




