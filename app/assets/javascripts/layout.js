(function() {

  $(document).ready(function() {
    $(".menu-list guide a").textShadow();
    $("input[type=\"checkbox\"]").ezMark();
    $(".srch_btn").live("click", function() {
      return $("#search_form").submit();
    });
    return $("ul.menu-list li a, .search_module .srch_btn, .sidebar .header_gray .title").textShadow();
  });

}).call(this);
