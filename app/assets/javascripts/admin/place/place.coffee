class @PlaceForm
  @self = undefined

  initialize: ->
    @template = ""

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
    params =
      category_id: item.id
    params.place_id = place_id if place_id
    @query(params)

  remove: (item) =>
    log 'remove'

  query: (params) =>
    $.getJSON '/admin/place_feature', params, ((data) => @render(data))

  render: (data) =>
    log 'g'
    log data