$(document).ready ->
  $(".left_block").lionbars()
  right_width = $(window).width() - 330
  $(".right_block").css "width", right_width
  $(".right_block .map img").css "width", right_width

