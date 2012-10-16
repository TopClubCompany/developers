(function() {

  this.Styx.Initializers.Explore = {
    initialize: function() {
      return $(function() {
        return $('a.close_btn').live("click", function() {
          return $('.recomed_popup').hide();
        });
      });
    },
    index: function(data) {
      return $(function() {
        var map, position;
        position = new google.maps.LatLng(data['point'].split(',')[0], data['point'].split(',')[1]);
        map = new google.maps.Map(document.getElementById("map"), {
          center: position,
          zoom: 14,
          mapTypeId: "roadmap",
          disableDefaultUI: true
        });
        google.maps.event.addDomListener(window, 'load', map);
        $('table.all_categories tr:last td:last').after("<td><div class='icon more'></div><a href='#'><span>Еще</span></a></td>");
        $(".recomed_popup#recomed_popup").css("z-index: 1000;");
        return $(".recomed_popup#recomed_popup").appendTo("#map.bdy");
      });
    }
  };

}).call(this);
