String::replaceAll = (token, newToken, ignoreCase) ->
  _token = undefined
  str = this + ""
  i = -1
  if typeof token is "string"
    if ignoreCase
      _token = token.toLowerCase()
      str = str.substring(0, i) + newToken + str.substring(i + token.length)  while (i = str.toLowerCase().indexOf(token, (if i >= 0 then i + newToken.length else 0))) isnt -1
    else
      return @split(token).join(newToken)
  str

jQuery.expr[":"].regex = (elem, index, match) ->
  matchParams = match[3].split(",")
  validLabels = /^(data|css):/
  attr =
    method: (if matchParams[0].match(validLabels) then matchParams[0].split(":")[0] else "attr")
    property: matchParams.shift().replace(validLabels, "")

  regexFlags = "ig"
  regex = new RegExp(matchParams.join("").replace(/^\s+|\s+$/g, ""), regexFlags)
  regex.test jQuery(elem)[attr.method](attr.property)

class @PlaceForm
  @self = undefined

  constructor: ->
    @template = Handlebars.compile($("#feature_group").html())

  @add: (item) =>
    @instance().add item

  @remove: (item) =>
    @instance().remove item

  @instance: =>
    unless @self
      @self = new PlaceForm()
    @self

  add: (item) =>
    place_id = $("#place_id").val()
    @category_id = item.id
    params =
      category_id: item.id
    params.place_id = place_id if place_id
    @query(params)

  remove: (item) =>
    $(".group_feature.container[data-id='#{item.id}'] :checked").click()
    $(".group_feature.container[data-id='#{item.id}']").hide()

  query: (params) =>
    $.getJSON '/admin/place_feature', params, ((data) => @render(data))

  render: (data) =>
    _.each data, (obj) =>
      obj.category_id = @category_id
      $('.features').append(@template(obj))

class Discount
  constructor: ->
    _.each $(".is_discount:checked"), (el) =>
      @hide(el)

    @bind_events()

  bind_events: ->
    self = @
    $(".is_discount").live 'change', ->
      $el = $(this)
      if @checked
        self.hide($el)
      else
        self.show($el)

  hide: (el) =>
    $el = $(el)
    $parent = $el.parents(".fields:first")
    $parent.find(".nav-tabs").hide()
    $parent.find(".tab-content").hide()

  show: (el) =>
    $el = $(el)
    $parent = $el.parents(".fields:first")
    $parent.find(".nav-tabs").show()
    $parent.find(".tab-content").show()

class CopyScheduler
  constructor: ->
    @bind_copy_action()

  bind_copy_action: ->
    self = @
    $(".btn.btn-primary.clone_schedule").live 'click', (e) ->
      $el = $(this)
      self.copy($el)

  copy: ($el) ->
    $container = $el.parent().parent()
    id = $($container.children("input")).val()
    string_id = $($container.children("input")).attr('id')
    string_id = string_id.replace('_id',"")
    number_id = string_id.replace('place_week_days_attributes_',"")
    parent_id = number_id - 1
    _.each ["start_at", "end_at", "is_working"], (field) =>
      @copy_field(string_id, parent_id, field)
    @copy_discounts($container, number_id)

  copy_field: (id, parent, field) ->
    string_parent_id = "#place_week_days_attributes_#{parent}_#{field}"
    value = $(string_parent_id).val()
    string_copy_id = "##{id}_#{field}"
    $el = $(string_copy_id)
    if field == "is_working"
      @copy_check_box_field($el, $(string_parent_id))
    else
      $el.val(value)

  copy_check_box_field: ($el, $parent) ->
    if $parent.is(":checked")
      $el.click() unless $el.is(":checked")
    else
      $el.click() if $el.is(":checked")

  copy_discounts: ($container, number_id) ->
    $parent =  $container.prev()
#    $parent = $("#parent_id_container").parent()
    fields = ["title_ru", "title_en", "title_ua", "description_ru", "description_en", "description_ua",
              "from_time", "to_time", "discount"]
    if $container.find(".discount_fields").size() == 0
      if $parent.find(".nested_fields .discount_fields").size() > 0
        _.each $parent.find(".nested_fields .discount_fields"), (discount) =>
          $discount = $(discount)
          $container.find(".add_nested_fields").click()
          $current_container = $container.find(".discount_fields:last")
          _.each fields, (field) =>
            val = $discount.find("input:regex(id, #{field}$)")?.val()
            $current_container.find("input:regex(id, #{field}$)")?.val(val)

          $el = $current_container.find("input:regex(id, is_discount$)")
          $parent = $discount.find("input:regex(id, is_discount$)")
          @copy_check_box_field($el, $parent)
$ ->
  new Discount()
  new CopyScheduler()




