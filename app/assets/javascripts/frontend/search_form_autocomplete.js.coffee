$ ->
  class Autocompleate
    request_delay: 400 #ms
    request_check_delay: 200
    last_keypress: 0
    autocomplete_selector: ''
    search_form_selector: '#search_form'
    autocomplete_url: '/autocomplete'
    method: 'get'
    updated_at: 0;
    search_value: ''
    is_search_value_new: false
    suggestions: []

    constructor: (config = {})->
      if $(@search_form_selector).length > 0
        el = @
        @init_config(config)
        @init_keyup_listener()
        @init_request_checker()


    init_config: (config)->
      el = @
      for key of config
        el[key] = config[key]

    init_keyup_listener: ->
      el = @
      el.search_value = $(el.autocomplete_selector).val()
      if $(el.autocomplete_selector).length > 0
        $(el.autocomplete_selector).keyup (e)->
          if (el.search_value != $(el.autocomplete_selector).val())
            el.search_value = $(el.autocomplete_selector).val()
            el.updated_at = Date.now()
            el.is_search_value_new = true

    init_request_checker: ->
      el = @
      setTimeout(f = (->
        el.request_checker()
        setTimeout f, delay
      ), delay = el.request_check_delay)

    request_checker: ->
      el = @
      if el.is_search_value_new
        if Date.now() - el.updated_at > el.request_check_delay
          $.getJSON(el.autocomplete_url + '?q=' + $(el.autocomplete_selector).val(),
            {}, (data)->
              el.suggestions = data.suggestions
              el.is_search_value_new = false
              $(el.autocomplete_selector).typeahead({source: el.suggestions})
              $(el.autocomplete_selector).keyup()
          )

  $(document).ready ->
    new Autocompleate({
      autocomplete_selector: '#title_or_location'
    })
