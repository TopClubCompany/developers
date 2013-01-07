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








