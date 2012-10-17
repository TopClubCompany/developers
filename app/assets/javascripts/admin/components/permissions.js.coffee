jQuery ->
  Handlebars.registerHelper 'link', (text, url) ->
    new Handlebars.SafeString "< a href = '" + url + "' > " + text + " < /a>"

  Handlebars.registerHelper 'new_id', (id) ->
    if isNaN(parseInt id)
      rand_n = Math.floor(Math.random() * 10000000)
      'new_' + rand_n
    else
      id

  Handlebars.registerHelper 'prop', (val) ->
    if typeof val is 'undefined'
      new Handlebars.SafeString 'disabled="1"'
    else if val
      new Handlebars.SafeString 'checked="1"'
    else
      ''

  Handlebars.registerHelper 'debug', (optValue) ->
    #console.log 'Context'
    #console.log @
    if optValue
      console.log 'Value'
      console.log optValue

  class Permissions
    constructor: (data) ->
      @perms_data = data
      @perms = []
      @populate()
      @render()

    populate: ->
      for v, i in @perms_data
        if v.is_collection
          @perms.push(new CollectionPermit(v))
        else
          @perms.push(new ResourcePermit(v))

    render: ->
      for p in @perms
        p.render()

    add: (is_collection = true)->
      if is_collection
        p_data = {subject: 3, actions: [], is_own: false, is_visibility: false, is_collection: true}
        perm = new CollectionPermit(p_data)
      else
        p_data = {subject: 3, actions: []}
        perm = new ResourcePermit(p_data)
      @perms.push(perm)
      perm.render()

    initHandlers: ->
      $('#add_collection_perm').click =>
        @add(true)
      $('#add_resource_perm').click =>
        @add(false)


  class BasePermit
    @subjects = $('.perms_form').data('subjects')
    constructor: (raw_data) ->
      @data = clone_obj raw_data
      @getRecordId()
      @getSubject()
      @getActions()

    getRecordId: ->
      if !@data.id? or isNaN(parseInt @data.id)
        rand_n = Math.floor(Math.random() * 10000000)
        @data.id = 'new_' + rand_n
        @data.new_record = true
      else
        @data.id = @data.id

    getSubject: ->
      @data.subject = to_i @data.subject
      @subject = BasePermit.subjects.valDetect(@data.subject)
      throw "No matched subject" unless @subject
      @data.class = @subject.klass
      if @subject.is_work
        @data.is_work = !!@data.is_work
      else
        delete @data.is_work

      if @subject.is_own
        @data.is_own = !!@data.is_own
      else
        delete @data.is_own

      if @subject.is_visibility
        @data.is_visibility = !!@data.is_visibility
      else
        delete @data.is_visibility

    getActions: ->
      key = if @data.is_collection then'collection_actions' else 'member_actions'
      actions = []
      return [] unless @subject[key]
      for a in @subject[key]
        a_obj = {}
        a_obj.is_checked = a['key'] in @data.actions
        a_obj.key = a.key
        a_obj.title = a.title
        actions.push(a_obj)
      @data.actions = actions

    setToken: ->
      initToken(@element.find('.ac_token'))


  class CollectionPermit extends BasePermit
    @template = Handlebars.compile($("#collection_perm_template").html())
    @actions_template = Handlebars.compile($("#collection_actions_template").html())
    @token_template = Handlebars.compile($("#collection_token_template").html())
    Handlebars.registerPartial('collection_actions', @actions_template)
    Handlebars.registerPartial('token_template', @token_template)

    constructor: (raw_data) ->
      super(raw_data)
      @container = $('#collection_perms')

    reloadSubject: ->
      @data.subject = to_i @subject_selector.val()
      @data.assoc = ''
      @data.actions = []
      @getSubject()
      @getActions()
      @renderActions()
      @renderAssoc()

    render: ->
      html = $(CollectionPermit.template(@data))
      @element = html.appendTo(@container)
      @renderAssoc()
      @initHandlers()

    renderAssoc: ->
      @assoc_select = @element.find('.assoc_select')
      assoc_data = [{caption: '', value: ''}]
      _.each @subject.assocs, (assoc) ->
        assoc_data.push {caption: assoc.title, value: assoc.key}
      @assoc_select.loadSelect(assoc_data)
      @assoc_select.val(@data.assoc)
      @assoc_select.change =>
        @data.assoc_pre = []
        @data.assoc = @assoc_select.val()
        @renderAssocToken()
      @renderAssocToken()

    renderAssocToken: ->
      if @data.assoc
        @getAssoc()
        @element.find('.assoc_token').html(CollectionPermit.token_template(@data))
        @setToken()

    getAssoc: ->
      @data.assoc_klass = @subject.assocs.valDetect(@data.assoc, 'key')?.klass
      throw "No matched assoc found for #{@data.assoc}" unless @data.assoc_klass

    renderActions: ->
      @element.find('.actions').html(CollectionPermit.actions_template(@data))

    initHandlers: ->
      @subject_selector = @element.find('.perm_subject')
      @subject_selector.val(@data.subject)

      @subject_selector.change =>
        @reloadSubject()


  class ResourcePermit extends BasePermit
    @template = Handlebars.compile($("#resource_perm_template").html())
    @actions_template = Handlebars.compile($("#resource_actions_template").html())
    Handlebars.registerPartial('resource_actions', @actions_template)

    constructor: (raw_data) ->
      super(raw_data)
      @container = $('#resource_perms')

    reloadSubject: ->
      @data.subject = to_i @subject_selector.val()
      @data.subject_pre = []
      @getSubject()
      @getActions()
      @renderActions()
      @setToken()

    render: ->
      html = $(ResourcePermit.template(@data))
      @element = html.appendTo(@container)
      @initHandlers()
      @setToken()

    renderActions: ->
      @element.find('.actions').html(ResourcePermit.actions_template(@data))

    initHandlers: ->
      @subject_selector = @element.find('.perm_subject')
      @subject_selector.val(@data.subject)

      @subject_selector.change =>
        @reloadSubject()

  perms_data = $('.perms_form').data('perms') || []
  window.permissions = new Permissions(perms_data)
  window.permissions.initHandlers()

