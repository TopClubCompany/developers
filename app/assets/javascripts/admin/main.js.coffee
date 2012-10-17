$ ->
  if $('#list')[0]
    $('#list tbody tr').live 'dblclick', (e) ->
      e.preventDefault()
      $el = $(this)
      window.location.href = $el.find('td a.resource_id_link').prop('href')

  window.initChosen = ->
    chosen_options =
      allow_single_deselect: true
      no_results_text: I18n.t('admin_js.no_results')
      placeholder_text_single: ' '
      placeholder_text_multiple: ' '
    $('form .do_chosen').chosen(chosen_options)
    chosen_multi_options = $.extend(chosen_options, {})
    $('form .do_chosen_multi').chosen(chosen_multi_options)

  initChosen()

  $('.simple_form').bind "nested:fieldAdded", =>
    initPickers()
    initChosen()
    initTokens()
