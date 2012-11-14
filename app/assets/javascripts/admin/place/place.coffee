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