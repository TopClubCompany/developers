(($) ->
  DEFAULT_CLASSES =
    tokenList: "token-input-list"
    token: "token-input-token"
    tokenDelete: "token-input-delete-token"
    selectedToken: "token-input-selected-token"
    highlightedToken: "token-input-highlighted-token"
    dropdown: "token-input-dropdown"
    dropdownItem: "token-input-dropdown-item"
    dropdownItem2: "token-input-dropdown-item2"
    selectedDropdownItem: "token-input-selected-dropdown-item"
    inputToken: "token-input-input-token"
    addToken: "token-input-add-token"

  DEFAULT_SETTINGS =
    IsFilterSearch: false
    customFilterParams: false
    method: "GET"
    queryParam: "q"
    searchDelay: 100
    minChars: 0
    propertyToSearch: "name"
    jsonContainer: null
    contentType: "json"
    parent_id: ""
    parent_name: ""
    addTokenAllow: false
    addTokenMethod: "POST"
    addTokenURL: ""
    prePopulate: null
    processPrePopulate: false
    hintText: "Type in a search term"
    noResultsText: I18n.t("admin_js.no_results")
    searchingText: I18n.t("admin_js.search")
    deleteText: "&times;"
    animateDropdown: true
    theme: null
    placeholderText: ''
    disabled: "token-input-disabled"
    placeholder: "token-input-placeholder"
    resultsFormatter: (item) ->
      "<li>" + item[@propertyToSearch] + "</li>"

    tokenFormatter: (item) ->
      "<li><p>" + item[@propertyToSearch] + "</p></li>"

    tokenLimit: null
    tokenDelimiter: ","
    preventDuplicates: true
    tokenValue: "id"
    onClickInput: null
    searchDuplicates: false
    addInputCollback: false
    addDeleteCollback: false
    onResult: null
    onAdd: null
    onDelete: null
    onReady: null
    idPrefix: "token-input-"

  POSITION =
    BEFORE: 0
    AFTER: 1
    END: 2

  KEY =
    BACKSPACE: 8
    TAB: 9
    ENTER: 13
    ESCAPE: 27
    SPACE: 32
    PAGE_UP: 33
    PAGE_DOWN: 34
    END: 35
    HOME: 36
    LEFT: 37
    UP: 38
    RIGHT: 39
    DOWN: 40
    NUMPAD_ENTER: 108
    MAC_COMMAND: 91

  methods =
    init: (url_or_data_or_function, options) ->
      settings = $.extend({}, DEFAULT_SETTINGS, options or {})
      @each ->
        $(this).data "tokenInputObject", new $.TokenList(this, url_or_data_or_function, settings)

    clear: ->
      @data("tokenInputObject").clear()
      this

    add: (item) ->
      @data("tokenInputObject").add item
      this

    remove: (item) ->
      @data("tokenInputObject").remove item
      this

    get: ->
      @data("tokenInputObject").getTokens()

  $.fn.tokenInput = (method) ->
    if methods[method]
      methods[method].apply this, Array::slice.call(arguments, 1)
    else
      methods.init.apply this, arguments

  class window.$.TokenList
    constructor: (input, url_or_data, settings) ->
      @input = input
      @url_or_data = url_or_data
      @settings = settings
      @init()
    checkTokenLimit: ->
      if @settings.tokenLimit isnt null and @token_count >= @settings.tokenLimit
        @input_box.hide()
        @hide_dropdown()
        return
    resize_input: ->
      return  if @input_val is (@input_val = @input_box?.val())
      escaped = @input_val.replace(/&/g, "&amp;").replace(/\s/g, " ").replace(/</g, "&lt;").replace(/>/g, "&gt;")
      @input_resizer.html escaped
      @input_box.width @input_resizer.width() + 30

    is_printable_character: (keycode) ->
      (keycode >= 48 and keycode <= 90) or (keycode >= 96 and keycode <= 111) or (keycode >= 186 and keycode <= 192) or (keycode >= 219 and keycode <= 222)

    insert_token: (item) ->
      @this_token = @settings.tokenFormatter(item)
      @this_token = $(@this_token).addClass(@settings.classes.token).insertBefore(@input_token)
      self = @
      $("<span>" + @settings.deleteText + "</span>").addClass(@settings.classes.tokenDelete).appendTo(@this_token).click ->
        self.delete_token $(this).parent()
        self.hidden_input.change()
        false

      @token_data =
        id: item.id
      @token_data[@settings.propertyToSearch] = item[@settings.propertyToSearch]
      $.data @this_token.get(0), "tokeninput", item
      @saved_tokens = @saved_tokens.slice(0, @selected_token_index).concat([@token_data]).concat(@saved_tokens.slice(@selected_token_index))
      @selected_token_index++
      @update_hidden_input @saved_tokens, @hidden_input
      @token_count += 1
      if @settings.tokenLimit isnt null and @token_count >= @settings.tokenLimit
        @input_box.hide()
        @hide_dropdown()
      @this_token

    add_token: (item) ->
      callback = @settings.onAdd
      if @token_count > 0 and @settings.preventDuplicates
        @found_existing_token = null
        self = @
        @token_list.children().each ->
          existing_token = $(this)
          existing_data = $.data(existing_token.get(0), "tokeninput")
          if existing_data and existing_data.id is item.id
            self.found_existing_token = existing_token
            false

        if @found_existing_token
          @select_token @found_existing_token
          @input_token.insertAfter @found_existing_token
          return
      if not @settings.tokenLimit? or @token_count < @settings.tokenLimit
        @insert_token item
        @checkTokenLimit()
      if @ctrlPressed
        @dropdown.css
          position: "absolute"
          top: $(@token_list).offset().top + $(@token_list).outerHeight()
          left: $(@token_list).offset().left
          "z-index": 999
      else
        @input_box.val ""
        @hide_dropdown()
      callback.call @hidden_input, item  if $.isFunction(callback) and @settings.addInputCollback

    select_token: (token) ->
      token.addClass @settings.classes.selectedToken
      @selected_token = token.get(0)
      @input_box.val ""
      @hide_dropdown()

    deselect_token: (token, position) ->
      token.removeClass @settings.classes.selectedToken
      @selected_token = null
      if position is POSITION.BEFORE
        @input_token.insertBefore token
        @selected_token_index--
      else if position is POSITION.AFTER
        @input_token.insertAfter token
        @selected_token_index++
      else
        @input_token.appendTo @token_list
        @selected_token_index = @token_count
      @input_box.focus()

    toggle_select_token: (token) ->
      @previous_selected_token = @selected_token
      @deselect_token $(@selected_token), POSITION.END  if @selected_token
      if @previous_selected_token is token.get(0)
        @deselect_token token, POSITION.END
      else
        @select_token token

    delete_token: (token) ->
      @token_data = $.data(token.get(0), "tokeninput")
      callback = @settings.onDelete
      index = token.prevAll().length
      index--  if index > @selected_token_index
      token.remove()
      @selected_token = null
      @saved_tokens = @saved_tokens.slice(0, index).concat(@saved_tokens.slice(index + 1))
      @selected_token_index--  if index < @selected_token_index
      @update_hidden_input @saved_tokens, @hidden_input
      @token_count -= 1
      @input_box.show().val("").focus()  if @settings.tokenLimit isnt null
      callback.call @hidden_input, @token_data  if $.isFunction(callback) and @settings.addDeleteCollback

    update_hidden_input: (saved_tokens, hidden_input) ->
      self = @
      @token_values = $.map(saved_tokens, (el) ->
        el[self.settings.tokenValue]
      )
      hidden_input.val @token_values.join(@settings.tokenDelimiter)

    hide_dropdown: ->
      @dropdown.hide().empty()
      @selected_dropdown_item = null

    show_dropdown: ->
      @dropdown.css(
        position: "absolute"
        top: $(@token_list).offset().top + $(@token_list).outerHeight()
        left: $(@token_list).offset().left
        "z-index": 999
      ).show()

    show_dropdown_searching: ->
      if @settings.searchingText
        @dropdown.html "<p>" + @settings.searchingText + "</p>"
        @show_dropdown()

    show_dropdown_hint: ->
      if @settings.hintText
        @dropdown.html "<p>" + @settings.hintText + "</p>"
        @show_dropdown()

    escape_regex_chars: (str) ->
      str?.replace /[-\[\]\/\{\}\(\)\*\+\?\.\\\^\$\|]/g, "\\$&"

    highlight_term: (value, term) ->
      self = @
      unless value
        ""
      else
        value.replace new RegExp("(?![^&;]+;)(?!<[^<>]*)(" + self.escape_regex_chars(term) + ")(?![^<>]*>)(?![^&;]+;)", "gi"), "<b>$1</b>"

    find_value_and_highlight_term: (template, value, term) ->
      self = @
      template.replace new RegExp("(?![^&;]+;)(?!<[^<>]*)(" + self.escape_regex_chars(value) + ")(?![^<>]*>)(?![^&;]+;)", "g"), self.highlight_term(value, term)

    populate_dropdown: (query, results) ->
      self = @
      if results and results.length
        self.dropdown.empty()
        self.dropdown_ul = $("<ul>").appendTo(self.dropdown).mouseover((event) ->
          self.select_dropdown_item $(event.target).closest("li")
        ).mousedown((event) ->
          self.add_token $(event.target).closest("li").data("tokeninput")
          self.hidden_input.change()
          false
        ).hide()
        @realArray_tokens = $.makeArray(@saved_tokens)
        @realArray_token_ids = []
        $.map @realArray_tokens, (val, i) ->
          self.realArray_token_ids.push parseInt(val.id)

        $.each results, (index, value) ->
          if $.inArray(parseInt(value.id), self.realArray_token_ids) < 0
            this_li = self.settings.resultsFormatter(value)
            this_li = self.find_value_and_highlight_term(this_li, value[self.settings.propertyToSearch], self.query)
            this_li = $(this_li).appendTo(self.dropdown_ul)
            if index % 2
              this_li.addClass self.settings.classes.dropdownItem
            else
              this_li.addClass self.settings.classes.dropdownItem2
            self.select_dropdown_item this_li  if index is 0
            $.data this_li.get(0), "tokeninput", value

        @show_dropdown()
        if @settings.animateDropdown
          @dropdown_ul.slideDown "fast"
        else
          @dropdown_ul.show()
      else
        if @settings.noResultsTextCallback && $.isFunction(@settings.noResultsTextCallback)
          @settings.noResultsTextCallback()
          @hide_dropdown()
        else
          @dropdown.html "<p>" + @settings.noResultsText + "</p>"
          @show_dropdown()

    select_dropdown_item: (item) ->
      if item
        @deselect_dropdown_item $(@selected_dropdown_item)  if @selected_dropdown_item
        item.addClass @settings.classes.selectedDropdownItem
        @selected_dropdown_item = item.get(0)

    deselect_dropdown_item: (item) ->
      item.removeClass @settings.classes.selectedDropdownItem
      @selected_dropdown_item = null

    do_search: ->
      self= @
      query = @input_box.val().toLowerCase()
      @deselect_token $(@selected_token), POSITION.AFTER  if @selected_token
      @show_dropdown_searching()
      clearTimeout @timeout
      @timeout = setTimeout(->
        self.run_search query
      , self.settings.searchDelay)

    run_search: (query) ->
      if query.length == 0
        @settings.onClickInput.call()  if $.isFunction(@settings.onClickInput)
      self = @
      cache_key = query + @computeURL()
      cached_results = @cache.get(cache_key)
      if cached_results and not @settings.IsFilterSearch
        @populate_dropdown query, cached_results
      else
        if @settings.url
          url = @computeURL()
          ajax_params = {}
          ajax_params.data = {}
          if url.indexOf("?") > -1
            parts = url.split("?")
            ajax_params.url = parts[0]
            param_array = parts[1].split("&")
            $.each param_array, (index, value) ->
              kv = value.split("=")
              ajax_params.data[kv[0]] = kv[1]
          else
            ajax_params.url = url
          if @settings.IsFilterSearch
            pdf_catalogue_id_in = $("#" + @settings.parent_id).attr("value")
            if pdf_catalogue_id_in.length < 1
              @hide_dropdown()
              return
            url += "&" + @settings.queryParam + "=" + query
            id_array = pdf_catalogue_id_in.split(",")
            i = 0

            while i < id_array.length
              url += "&" + encodeURIComponent("q[" + self.settings.parent_name + "][]") + "=" + id_array[i]
              i++
            $.getJSON url, (results) ->
              results = self.settings.onResult.call(self.hidden_input, results)  if $.isFunction(self.settings.onResult)
              self.cache.add cache_key, (if self.settings.jsonContainer then results[self.settings.jsonContainer] else results)  unless self.settings.IsFilterSearch
              self.populate_dropdown query, (if self.settings.jsonContainer then results[self.settings.jsonContainer] else results)  if self.input_box.val().toLowerCase() is query
          else if @settings.customFilterParams
            custom_params = {}
            $.each @settings.customFilterParams, (k, v) ->
              param_values = {}
              $.each v, (kk, vv) ->
                param_val = $("#" + vv).val()
                param_values[kk] = param_val  if param_val

              custom_params[k] = param_values

            url += "&" + @settings.queryParam + "=" + query + "&" + $.param(custom_params)
            $.getJSON url, (results) ->
              results = self.settings.onResult.call(self.hidden_input, results)  if $.isFunction(self.settings.onResult)
              self.populate_dropdown query, (if self.settings.jsonContainer then results[self.settings.jsonContainer] else results)  if self.input_box.val().toLowerCase() is query
          else
            ajax_params.data[@settings.queryParam] = query
            ajax_params.type = @settings.method
            ajax_params.dataType = @settings.contentType
            ajax_params.dataType = "json"  if @settings.crossDomain
            ajax_params.success = (results) ->
              results = self.settings.onResult.call(self.hidden_input, results)  if $.isFunction(self.settings.onResult)
              self.cache.add cache_key, (if self.settings.jsonContainer then results[self.settings.jsonContainer] else results)  unless self.settings.IsFilterSearch
              self.populate_dropdown query, (if self.settings.jsonContainer then results[self.settings.jsonContainer] else results)  if self.input_box.val().toLowerCase() is query

            ajax_params.error = (error) ->
              switch error.status
                when 403
                  alert "403: You are unauthorized to view the token endpoint."
                when 404
                  alert "404: Token endpoint does not exist."

            $.ajax ajax_params
        else if @settings.local_data
          results = $.grep(@settings.local_data, (row) ->
            row[self.settings.propertyToSearch].toLowerCase().indexOf(query.toLowerCase()) > -1
          )
          results = self.settings.onResult.call(self.hidden_input, results)  if $.isFunction(self.settings.onResult)
          self.cache.add cache_key, results
          self.populate_dropdown query, results

    computeURL: ->
      self = @
      url = @settings.url
      url = @settings.url.call()  if typeof @settings.url is "function"
      url
    init: ->
      self = @
      if $.type(@url_or_data) is "string" or $.type(@url_or_data) is "function"
        @settings.url = @url_or_data
        url = @computeURL()
        if @settings.crossDomain is undefined
          if url.indexOf("://") is -1
            @settings.crossDomain = false
          else
            @settings.crossDomain = (location.href.split(/\/+/g)[1] isnt url.split(/\/+/g)[1])
      else @settings.local_data = @url_or_data  if typeof (@url_or_data) is "object"
      if @settings.classes
        @settings.classes = $.extend({}, DEFAULT_CLASSES, self.settings.classes)
      else if @settings.theme
        @settings.classes = {}
        $.each DEFAULT_CLASSES, (key, value) =>
          @settings.classes[key] = value + "-" + @settings.theme
      else
        self.settings.classes = DEFAULT_CLASSES
      unless @settings.addTokenURL is ""
        @settings.addTokenAllow = true
        @settings.noResultsText = I18n.t("admin_js.no_results") + " <a href=\"#\" class=\"" + $(@input).attr("id") + "\">" + I18n.t("admin_js.add_link") + "</a>"
      @settings.classes.addToken = $(@input).attr("id")
      @saved_tokens = []
      @token_count = 0
      @cache = new $.TokenList.Cache()
      @timeout = undefined
      @input_val = undefined
      @ctrlPressed = false
      window.in = self.input
      placeholder = $(self.input).attr('placeholder')
      @input_box = $("<input type=\"text\"  autocomplete=\"off\">").css(outline: "none").attr("id", self.settings.idPrefix + self.input.id).attr('placeholder',placeholder).focus(->
        if self.settings.tokenLimit is null or self.settings.tokenLimit isnt self.token_count
          self.blur = false
          self.show_dropdown_hint()
          self.do_search()
          setTimeout (->
              self.blur = true
          ), 400
      ).blur(->
        setTimeout (->
          if self.blur
            self.hide_dropdown()
            self.blur = true
        ), 400
        $(this).val ""
      ).bind("keyup keydown blur update", self.resize_input).keydown((event) ->
        self.previous_token = undefined
        self.next_token = undefined
        switch event.keyCode
          when KEY.LEFT, KEY.RIGHT
          , KEY.UP
          , KEY.DOWN
            if not $(this).val() and $(this).val().length isnt 0
              self.previous_token = self.input_token.prev()
              self.next_token = self.input_token.next()
              if (self.previous_token.length and self.previous_token.get(0) is self.selected_token) or (self.next_token.length and self.next_token.get(0) is self.selected_token)
                if event.keyCode is KEY.LEFT or event.keyCode is KEY.UP
                  self.deselect_token $(self.selected_token), POSITION.BEFORE
                else
                  self.deselect_token $(self.selected_token), POSITION.AFTER
              else if (event.keyCode is KEY.LEFT or event.keyCode is KEY.UP) and self.previous_token.length
                self.select_token $(self.previous_token.get(0))
              else self.select_token $(self.next_token.get(0))  if (event.keyCode is KEY.RIGHT or event.keyCode is KEY.DOWN) and self.next_token.length
            else
              self.dropdown_item = null
              if event.keyCode is KEY.DOWN or event.keyCode is KEY.RIGHT
                self.dropdown_item = $(self.selected_dropdown_item).next()
              else
                self.dropdown_item = $(self.selected_dropdown_item).prev()
              self.select_dropdown_item self.dropdown_item  if self.dropdown_item.length
              return false
          when KEY.BACKSPACE
            self.previous_token = self.input_token.prev()
            unless $(this).val().length
              if self.selected_token
                self.delete_token $(self.selected_token)
                self.hidden_input.change()
              else self.select_token $(self.previous_token.get(0))  if self.previous_token.length
              return false
            else if $(this).val().length is 1
              self.hide_dropdown()
            else
              setTimeout (->
                self.do_search()
              ), 5
          when KEY.TAB, KEY.ENTER
          , KEY.NUMPAD_ENTER
          , KEY.COMMA
            if self.selected_dropdown_item
              self.add_token $(self.selected_dropdown_item).data("tokeninput")
              self.hidden_input.change()
              return false
          when KEY.ESCAPE
            self.hide_dropdown()
            true
          else
            if event.ctrlKey or event.which is KEY.MAC_COMMAND
              self.ctrlPressed = true
            else
              if String.fromCharCode(event.which)
                setTimeout (->
                  self.do_search()
                ), 5
      ).keyup((event) ->
        self.ctrlPressed = false  if event.ctrlKey or event.which is KEY.MAC_COMMAND
      )
      self.hidden_input = $(self.input).hide().val("").focus(->
        self.input_box.focus()
      ).blur(->
        self.input_box.blur()
      )
      self.selected_token = null
      self.selected_token_index = 0
      self.selected_dropdown_item = null
      self.token_list = $("<ul />").addClass(self.settings.classes.tokenList).click((event) ->
        li = $(event.target).closest("li")
        if li and li.get(0) and $.data(li.get(0), "tokeninput")
          self.toggle_select_token li
        else
          self.deselect_token $(self.selected_token), POSITION.END  if self.selected_token
          self.input_box.focus()
      ).mouseover((event) ->
        li = $(event.target).closest("li")
        li.addClass self.settings.classes.highlightedToken  if li and self.selected_token isnt this
      ).mouseout((event) ->
        li = $(event.target).closest("li")
        li.removeClass self.settings.classes.highlightedToken  if li and self.selected_token isnt this
      ).insertBefore(self.hidden_input)
      self.input_token = $("<li />").addClass(self.settings.classes.inputToken).appendTo(self.token_list)
      $(self.input_token).append(self.input_box)
      self.dropdown = $("<div>").addClass(self.settings.classes.dropdown).appendTo("body").hide()
      self.input_resizer = $("<tester/>").insertAfter(self.input_box).css(
        position: "absolute"
        top: -9999
        left: -9999
        width: "auto"
        fontSize: self.input_box.css("fontSize")
        fontFamily: self.input_box.css("fontFamily")
        fontWeight: self.input_box.css("fontWeight")
        letterSpacing: self.input_box.css("letterSpacing")
        whiteSpace: "nowrap"
      )
      if self.settings.addTokenAllow
        $("." + self.settings.classes.addToken).die("click").live "click", (e) ->
          e.preventDefault()
          if $.isFunction(self.settings.createCallback)
            self.settings.createCallback.call()
            return
          tagName = self.input_token.find("input:first").data("tag")
          addURL = self.settings.addTokenURL
          contentType = (if (self.settings.crossDomain) then "jsonp" else self.settings.contentType)
          if tagName and tagName.length > 0
            $.ajax
              url: addURL
              type: self.settings.addTokenMethod
              data:
                q: tagName

              dataType: "json"
              success: (newTag) ->
                if newTag
                  self.dropdown.find("p").text "Added!"
                  self.add_token newTag
                  setTimeout (->
                    self.hide_dropdown()
                  ), 2000
      self.hidden_input.val ""
      li_data = self.settings.prePopulate or self.hidden_input.data("pre")
      li_data = self.settings.onResult.call(self.hidden_input, li_data)  if self.settings.processPrePopulate and $.isFunction(self.settings.onResult)
      if li_data and li_data.length
        $.each li_data, (index, value) ->
          self.insert_token value
          self.checkTokenLimit()
      self.settings.onReady.call()  if $.isFunction(self.settings.onReady)
    clear:  ->
      self = @
      self.token_list.children("li").each ->
        self.delete_token $(this)  if $(this).children("input").length is 0

    add: (item) ->
      @add_token item

    has_tokens: ->
      !!@saved_tokens.length

    remove: (item) ->
      self = @
      @token_list.children("li").each ->
        if $(this).children("input").length is 0
          self.currToken = $(this).data("tokeninput")
          match = true
          for prop of item
            if item[prop] isnt currToken[prop]
              match = false
              break
          self.delete_token $(this)  if match

    getTokens: ->
      self.saved_tokens

  class window.$.TokenList.Cache
    constructor: (options) ->
      @settings = $.extend(
        max_size: 500
      , options)
      @data = {}
      @size = 0
    flush: ->
      @data = {}
      @size = 0

    add: (query, results) ->
      @flush()  if @size > @settings.max_size
      @size += 1  unless @data[query]
      @data[query] = results

    get: (query) ->
      @data[query]
) jQuery
