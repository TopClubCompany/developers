$ ->
  if $('#list')[0]
    $("#list input.toggle").live "click", ->
      $("#list [name='ids[]']").attr "checked", $(this).is(":checked")

    $('.batch_action_link').live 'click', (e) ->
      e.preventDefault()
      if $("#list [name='ids[]']:checked")[0]
        action = $(this).data('action')
        $('#batch_action').val(action)
        if action == 'destroy'
          $('#model_confirmation').modal('toggle')
        else
          $('#batch_action_form').submit()

    $('#confirm_delete').live 'click', (e) ->
      e.preventDefault()
      $('#model_confirmation').modal('hide')
      $('#batch_action_form').submit()
