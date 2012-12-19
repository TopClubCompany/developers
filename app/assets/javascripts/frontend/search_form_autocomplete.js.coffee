$ ->
 $("#title_or_location").autocomplete
  source: (request, response) ->
    $.ajax
      url: "/autocomplete"
      dataType: "jsonp"
      data:
        featureClass: "P"
        style: "full"
        maxRows: 12
        name_startsWith: request.term

      success: (data) ->
        response $.map(data, (item) ->
          label: item.name + ((if item.street then ", " + item.street else "")) + ", " + ((if item.county then ", " + item.county else ""))
          value: item.name
        )


  minLength: 3
  select: (event, ui) ->
    log (if ui.item then "Selected: " + ui.item.label else "Nothing selected, input was " + @value)

  open: ->
    $(this).removeClass("ui-corner-all").addClass "ui-corner-top"

  close: ->
    $(this).removeClass("ui-corner-top").addClass "ui-corner-all"
    
  # if $("#title_or_location").length > 0
    # $("#title_or_location").on 'change', ->
      # if $(this).val().length > 3
        # $.getJSON "autocomplete?q=#{$(this).val()}", (data) ->  
          # console.log data



