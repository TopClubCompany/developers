$(document).ready ->
  $(".gray_button.list, .gray_button.block").live "click", ->
    $(".gray_button").removeClass("active")
    $(this).addClass("active")
    module_class = $(this).attr("class")
    unless module_class.indexOf("list") is -1
      $(".feed_event_list, .right_feed").show()
      $(".feed_event_blocks").hide()
      $(".mainsteam").addClass("narrow_floated")
    else
      $(".feed_event_list, .right_feed").hide()
      $(".feed_event_blocks").show()
      $(".mainsteam").removeClass("narrow_floated")