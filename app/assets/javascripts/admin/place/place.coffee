class @PlaceForm
  @self = undefined

  initialize: ->
    @template = ""

  @add: (item) =>
    @instance.add item

  @remove: (item) =>
    @instance.remove item

  @instance: =>
    unless @self
      @self = new @PlaceForm()
    @self

  add: (item) =>
    log 'add'
    log item

  remove: (item) =>
    log 'remove'