window.initTokens = ->
  for el in $('form .ac_token')
    $el = $(el)
    unless $el.hasClass('ac_token_done')
      initToken(el)
      $el.addClass('ac_token_done')

window.initImageTokens = ->
  for el in $(".ac_imgage_token")
    initImageToken(el)

window.initToken = (el) ->
  $el = $(el)
  options =
    theme: "facebook"
    crossDomain: false
    addTokenURL: $el.data('add')
    addTokenAllow: $el.data('add_new')
    prePopulate: $el.data("pre")
    customFilterParams: $el.data("c")
    tokenLimit: $el.data("limit")
    token_add_function: $el.data("token_add_function")
    token_delete_function: $el.data("token_delete_function")
    animateDropdown: false
  if options.token_add_function?
    options.addInputCollback = true
    options.onAdd = ( (item) -> window[options.token_add_function].add(item))
  if options.token_delete_function?
    options.addDeleteCollback = true
    options.onDelete = ((item) -> window[options.token_delete_function].remove(item))
  $el.tokenInput("/admin/autocomplete?" + $.param({class: $el.data('class'), token: 1}), options)

window.initImageToken = (el) ->
  $el = $(el)
  opts =
    theme: "facebook", crossDomain: false
    prePopulate: $el.data("pre")
    customFilterParams: $el.data("c")
    animateDropdown: false
    resultsFormatter: (item) -> "<li><img src='#{item.url}' title='#{item.name} #{item.sku}' height='50px' width='50px' />
                                              <div style='display: inline-block; padding-left: 10px;'>
                                              <div class='module_name'>#{item.name}<br/><b>#{item.sku}<b></div></div></li>"
    tokenFormatter: (item) -> "<li><p><a href='/admin/#{$el.data('collection')}/#{item.id}/edit' target='_blank'>#{item.name} - #{item.sku}</a></p></li>"
  $el.tokenInput("/admin/autocomplete?" + $.param({class: $el.data('class'), token: 1}), opts)

$ ->
  window.initTokens()
  window.initImageToken()
