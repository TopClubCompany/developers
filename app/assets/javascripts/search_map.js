(function() {

  $(document).ready(function() {
    var right_width;
    $(".left_block").lionbars();
    right_width = $(window).width() - 330;
    $(".right_block").css("width", right_width);
    return $(".right_block .map img").css("width", right_width);
  });

}).call(this);
