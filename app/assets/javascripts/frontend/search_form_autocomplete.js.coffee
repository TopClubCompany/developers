$ ->
  if $("#title_or_location").length > 0
    $("#title_or_location").on 'keyup', ->
      if $(this).val().length >= 3
        $.getJSON "autocomplete?q=#{$(this).val()}", (data) ->  
          console.log $.map data, (n, i) ->
            n.county



