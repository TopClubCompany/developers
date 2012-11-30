#$(document).ready ->
 # $('.scroll-pane').jScrollPane();
$(window).scroll ->
  diffHeight = $('#wrapper').height() - $('#listing').height();
  if $(window).scrollTop() < 229
    $('#mapcontainer').removeClass('fixed');
    $('#mapcontainer').removeClass('bottom');
    $('#mapcontainer').css('bottom','');
  else if ($(window).scrollTop() >= 229) && (diffHeight > $(window).scrollTop())
    $('#mapcontainer').css('bottom','');
    $('#mapcontainer').removeClass('bottom');
    $('#mapcontainer').addClass('fixed');
    console.log(diffHeight + " > " + $(window).scrollTop());
  else if diffHeight <= $(window).scrollTop()
    heightNew = $('#search_results .span2').height() - $('#listing').height() + 10;
    $('#mapcontainer').removeClass('fixed');
    $('#mapcontainer').addClass('bottom');
    $('#mapcontainer').css('bottom','-'+heightNew+'px');
    console.log(diffHeight + " <= " + $(window).scrollTop());






