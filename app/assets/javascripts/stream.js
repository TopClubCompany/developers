(function() {

  $(document).ready(function() {
    return $(".gray_button.list, .gray_button.block").live("click", function() {
      var module_class;
      $(".gray_button").removeClass("active");
      $(this).addClass("active");
      module_class = $(this).attr("class");
      if (module_class.indexOf("list") !== -1) {
        $(".feed_event_list, .right_feed").show();
        $(".feed_event_blocks").hide();
        return $(".mainsteam").addClass("narrow_floated");
      } else {
        $(".feed_event_list, .right_feed").hide();
        $(".feed_event_blocks").show();
        return $(".mainsteam").removeClass("narrow_floated");
      }
    });
  });

}).call(this);
