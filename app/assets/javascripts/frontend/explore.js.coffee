#$(document).ready ->
 # $('.scroll-pane').jScrollPane();
### 
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
  else if diffHeight <= $(window).scrollTop()
    heightNew = $('#search_results .span2').height() - $('#listing').height() + 10;
    $('#mapcontainer').removeClass('fixed');
    $('#mapcontainer').addClass('bottom');
    $('#mapcontainer').css('bottom','-'+heightNew+'px');
###

$ ->
  class Projector
    constructor: ->
      @init()

    init: =>
      projekktor('#video-container', {
        controls: true,
        plugins: ['display', 'controlbar'],
        plugin_controlbar: {
          controlsDisableFade: true,
        }
      }, (player) ->
        player.addListener('start', (data) ->
          $('#teaser .video_player h5').css('display', 'none')
        )
      )

  $(document).ready ->
    new Projector() if $(".video_player").size() > 0








