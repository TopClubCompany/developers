(function() {
  var disable_user_rating, load_places;

  load_places = function(data) {
    $("#more_places_link").remove();
    $("#new_loader").before(data);
    $("#more_places_link").hide();
    return $("#new_loader").hide();
  };

  disable_user_rating = function(data) {
    $('#user_rating').raty({
      readOnly: true,
      score: data
    });
    return $('#user_rating').addClass("half_opacity");
  };

  this.Styx.Initializers.Places = {
    initialize: function() {
      return $(function() {
        $(".tabs_module li:first").next().toggleClass("active");
        $(".tabs_module li.active").next().css("border-left", "white 1px solid");
        $("ul.category").children(".element").each(function(index, obj) {
          if (index > 3) {
            return $(obj).hide();
          }
        });
        $("span.more_category_btn").live("click", function() {
          return $("ul.category").children(".element").each(function(index, obj) {
            if (index > 3) {
              $(obj).show();
            }
            return $("span.more_category_btn").parent().remove();
          });
        });
        $("ul.kitchen").children(".element").each(function(index, obj) {
          if (index > 3) {
            return $(obj).hide();
          }
        });
        $("span.more_kitchen_btn").live("click", function() {
          return $("ul.kitchen").children(".element").each(function(index, obj) {
            if (index > 3) {
              $(obj).show();
            }
            return $("span.more_kitchen_btn").parent().remove();
          });
        });
        $("span.sort_btn").live("click", function() {
          $(".buttom_second").removeClass("active");
          return $(this).parents(".buttom_second").addClass("active");
        });
        $(".collection_filtres li").live("click", function() {
          $(this).toggleClass("active");
          return $(this).parents(".buttom_second").removeClass("active");
        });
        $(".tabs_module li").live("click", function() {
          var block;
          $(".tabs_module li.active").next().css("border-left", "#ccc 1px solid");
          $(".tabs_module li").removeClass("active");
          $(this).addClass("active");
          $(".tabs_module li.active").next().css("border-left", "white 1px solid");
          $(".tabs_module>div").hide();
          block = $(".tabs_module li.active").attr("block");
          return $("." + block).show();
        });
        return $('form#filter').live("ajax:success", function(obj, data, status, xhr) {
          $(".show_result.cf").remove();
          return load_places(data);
        });
      });
    },
    index: function(data) {
      return $(function() {
        var center_marker, center_position, icon, index, lat_lng, latlngbounds, map, marker, opts, place, places;
        center_position = new google.maps.LatLng(data['point'].split(',')[0], data['point'].split(',')[1]);
        map = new google.maps.Map(document.getElementById("right_map"), {
          center: center_position,
          zoom: 14,
          mapTypeId: "roadmap",
          disableDefaultUI: true
        });
        center_marker = new google.maps.Marker({
          position: center_position,
          map: map
        });
        if (data['places'].length > 0) {
          latlngbounds = new google.maps.LatLngBounds();
          places = (function() {
            var _ref, _results;
            _ref = data['places'];
            _results = [];
            for (index in _ref) {
              place = _ref[index];
              lat_lng = place[0];
              icon = place[1];
              marker = new google.maps.Marker({
                position: new google.maps.LatLng(lat_lng.split(',')[0], lat_lng.split(',')[1]),
                title: icon
              });
              marker.setMap(map);
              _results.push(latlngbounds.extend(marker.getPosition()));
            }
            return _results;
          })();
          map.setCenter(latlngbounds.getCenter(), map.fitBounds(latlngbounds));
        }
        google.maps.event.addDomListener(window, 'load', map);
        $('.filter_val').live('change', function() {
          return $('form#filter').submit();
        });
        $("#new_loader").hide();
        $("#more_places_link").hide();
        opts = {
          offset: '100%'
        };
        return $(".footer").waypoint((function(event, direction) {
          if (direction === "down" && $("#more_places_link").length) {
            $(".footer").waypoint('remove');
            $("#new_loader").show();
            return $.get($("#more_places_link").attr("href"), function(data) {
              load_places(data);
              return $(".footer").waypoint(opts);
            });
          }
        }), opts);
      });
    },
    show: function(data) {
      return $(function() {
        var map, marker, position;
        position = new google.maps.LatLng(data['point'].split(',')[0], data['point'].split(',')[1]);
        map = new google.maps.Map(document.getElementById("map"), {
          center: position,
          zoom: 14,
          mapTypeId: "roadmap",
          disableDefaultUI: true
        });
        marker = new google.maps.Marker({
          position: position,
          map: map
        });
        google.maps.event.addDomListener(window, 'load', map);
        $('#map.map').resizable({
          maxWidth: 620,
          minWidth: 620,
          minHeight: 145
        });
        addthis.button("#at_button", {
          ui_click: true
        }, {});
        $('#submit_review').live('click', function() {
          $('form.edit_place').submit();
          return false;
        });
        $('a.add_to').live("ajax:success", function(obj, data, status, xhr) {
          $('#' + data[0]).html(data[1]);
          $(this).removeAttr("href");
          $(this).removeAttr("data-remote");
          $(this).removeAttr("data-method");
          return $(this).parent().parent().addClass("half_opacity");
        });
        $('#rating').raty({
          readOnly: true,
          score: data['rating']
        });
        if (data['can_be_rated']) {
          $('#user_rating').raty({
            score: function() {
              return $(this).attr('data-rating');
            },
            click: function(rating, e) {
              return $.post(data['rating_url'], {
                "place": {
                  "rating": rating
                }
              }, function(result) {
                $('#rating').raty({
                  readOnly: true,
                  score: result
                });
                return disable_user_rating(result);
              });
            }
          });
        } else {
          disable_user_rating(data['rating']);
        }
        if (!data['can_be_favorite']) {
          $('.act_btn.favorits .middle a').removeAttr("href");
          $('.act_btn.favorits .middle a').removeAttr("data-remote");
          $('.act_btn.favorits .middle a').removeAttr("data-method");
          $('.act_btn.favorits').addClass("half_opacity");
        }
        if (!data['can_be_planned']) {
          $('.act_btn.add_plans .middle a').removeAttr("href");
          $('.act_btn.add_plans .middle a').removeAttr("data-remote");
          $('.act_btn.add_plans .middle a').removeAttr("data-method");
          $('.act_btn.add_plans').addClass("half_opacity");
        }
        if (!data['can_be_visited']) {
          $('.act_btn.check_in .middle a').removeAttr("href");
          $('.act_btn.check_in .middle a').removeAttr("data-remote");
          $('.act_btn.check_in .middle a').removeAttr("data-method");
          return $('.act_btn.check_in').addClass("half_opacity");
        }
      });
    }
  };

}).call(this);
