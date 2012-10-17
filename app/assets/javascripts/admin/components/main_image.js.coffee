class MainImg
  constructor: ->
    @init_observe()

  init_observe: ->
    self = @
    $(".main_image").live 'click', (e) ->
      e.preventDefault()
      id = $(this).data('id')
      parent_container = $(this).parents("div:first")
      self.set_main(id,parent_container)

  set_main: (new_main_id, parent_container) =>
    @new_main_id = new_main_id
    @old_main_id = @get_old_id()
    data =
      new_main_id: new_main_id
      old_main_id: (@old_main_id unless parseInt(@new_main_id) == @old_main_id)
    $.post "/admin/main_image", data, ((data) => @change_img(data)), 'json'

  get_old_id: ->
    $(".one_asset").find(".asset.ill:first").data('id')

  change_img: (data) ->
    #js change images
      parent = $("#asset_#{@new_main_id}").parent()
      span = "<span class='main_img' data-id='#{@old_main_id}'>#{I18n.t("admin_js.set_img")}</span>"
      $("#asset_#{@old_main_id}").append(span)
      $("#asset_#{@old_main_id}").appendTo(parent)
      $(".resource_main_img:first .fileupload-list.ill-bl.galery").html('')
      $("#asset_#{@new_main_id}").find(".main_img").remove()
      $("#asset_#{@new_main_id}").appendTo($(".one_asset .fileupload-list.ill-bl.galery"))

$ ->
  if $('#action_edit, #action_new')[0]
    new MainImg()