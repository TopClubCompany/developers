class window.NestedFieldsAdder
  constructor: (@opts={}) ->
    _.defaults @opts,
      tokens: true
      ez_mark: false
      assets: true
      fileupload: true
      tabs: true
    log @opts

    @form = $('form.simple_form:first')
    if @form.find('.nested_fields')[0]
      @form.bind "nested:fieldAdded", (e) =>
        @after_nested_add_new(e.field, e.new_id)

  after_nested_add_new: ($field, new_id) ->
    $nested_fields = $field.closest('.nested_fields')
    data =
      base_model_key: $nested_fields.data('base_model_key')
      nested_assoc: $nested_fields.data('nested_assoc')

    if @opts.fileupload
      $guid = $field.find("[name=\"#{data.base_model_key}[#{data.nested_assoc}_attributes][new_#{new_id}][fileupload_guid]\"]")
      if $guid[0]
        $fileupload = $field.find('.fileupload')
        data.klass = $fileupload.data('klass')
        data.assoc = $fileupload.data('assoc')
        data.multiple = $fileupload.data('multiple')

        fileupload_id = "#{data.assoc}_#{new_id}_#{data.nested_assoc}"
        $fileupload.prop('id', fileupload_id)
        $guid.val new_id
        new qq.FileUploaderInput(
          action: "/sunrise/fileupload?method=#{data.assoc}&assetable_type=#{data.klass}&guid=#{new_id}"
          allowedExtensions: [ "jpg", "jpeg", "png", "gif" ]
          multiple: data.multiple
          element: fileupload_id
        )
        $guid.closest('.fields').data('guid', new_id)

      if @opts.assets
        Manage.init_assets fileupload_id, "/admin/assets/sort", false

    $field.closest('.fields').find('input[type="checkbox"]').ezMark() if @opts.ez_mark
    window.initTokens() if @opts.tokens
    window.locale_tabs.initHandlers() if @opts.tabs
