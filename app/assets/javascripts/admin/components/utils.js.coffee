window.gon ||= {}
window.locale_path = ->
  if I18n.locale == 'ru' then '' else "/#{I18n.locale}"

$.fn.serializeJSON = ->
  json = {}
  jQuery.map $(this).serializeArray(), (n) ->
    json[n["name"]] = n["value"]

  json

$.fn.unescape = ->
  $(this).html $.unescape($(this).html())

$.unescape = (html) ->
  htmlNode = document.createElement("div")
  htmlNode.innerHTML = html
  return htmlNode.innerText  if htmlNode.innerText
  htmlNode.textContent

$.fn.emptySelect = ->
  @each ->
    @options.length = 0  if @tagName is "SELECT"

$.fn.loadSelect = (optionsDataArray) ->
  @emptySelect().each ->
    if @tagName is "SELECT"
      selectElement = this
      $.each optionsDataArray, (index, optionData) ->
        option = new Option(optionData.caption, optionData.value)
        if $.browser.msie
          selectElement.add option
        else
          selectElement.add option, null

window.replaceURLWithHTMLLinks = (text) ->
  exp = /(\b(https?|ftp|file):\/\/[-A-Z0-9+&@#\/%?=~_|!:,.;]*[-A-Z0-9+&@#\/%=~_|])/ig
  text.replace(exp, "<a href='$1' target='_blank'>$1</a>")

$.parseQuery = ->
  window.location.search.replace("?", "").parseQuery()

String::parseQuery = ->
  h = {}
  qs = $.trim(this).match(/([^?#]*)(#.*)?$/)[0]
  return {}  unless qs
  pairs = qs.split("&")
  $.each pairs, (i, v) ->
    pair = v.split("=")
    h[pair[0]] = pair[1]
  h

Array::valDetect = (v, prop = 'id') ->
  res = null
  for el in @
    if el[prop] is v
      res = el
  res

Array::includes = (obj) ->
  for el, i in @
    if el == obj
      return i
  return false

Array::remove = ->
  what = undefined
  a = arguments
  L = a.length
  ax = undefined
  while L and @length
    what = a[--L]
    until (ax = @indexOf(what)) is -1
      @splice ax, 1
      break;
  this

window.to_i = (val) ->
  unless val
    return 0
  val = parseInt val, 10
  if isNaN(val) then 0 else val

window.to_f = (val) ->
  unless val
    return 0.0
  val = parseFloat val, 10
  if isNaN(val) then 0.0 else val

window.log = (objects...) ->
  unless window.gon?.no_log
    console.log '== debug ==='
    console.log objects

window.clone_obj = (obj) ->
  if notobj? or typeof obj isnt 'object'
    return obj

  newInstance = new obj.constructor()

  for key of obj
    newInstance[key] = clone_obj obj[key]

  return newInstance

class window.PageScrollEvent
    constructor: ->
      default_page = window.location.href.match(/\d+$/g)
      if default_page != null
        @page = parseInt(default_page)
      else
        @page = 1
      $(window).unbind('scroll',@check)
      @load_data()
      if $(window).height() == $(document).height()
        $(window).trigger('scroll')

    nearBottom: ->
      $(window).scrollTop() > $(document).height() - $(window).height() - 250

    check: =>
      if @nearBottom()
        @page++
        $(window).unbind('scroll',@check)
        @load_data()

    load_data: ()->

    render: (data) ->
      unless @data[@data.length - 1]?.all_size == undefined
        count = @data[@data.length - 1].all_size
        $(".toTop_wrap .qty").text(count)
        window.TopScroll.all_elements = count
        @data.pop()
      @change_up_down()

    change_up_down: ->
      if @data?.entries != undefined
        if @data?.entries.length > 1
          window.TopScroll.is_down = false
        else
          window.TopScroll.is_down = true
      else
        if @data.length > 1
          window.TopScroll.is_down = false
        else
          window.TopScroll.is_down = true




jQuery.fn.tip = (options) ->
  @each ->
    jQuery(this).hover (->
      toolTipText = jQuery(this).text()
      popup = "<em class=\"tooltip\">" + toolTipText + "<em></em></em>"
      $(popup).appendTo this
      $(popup).fadeIn 200
    ), (->
      $(this).find("em.tooltip").remove()
    )
