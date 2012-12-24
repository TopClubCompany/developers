$(document).ready ->
  $('.add_to_favorites').click ->
    $(this).toggleClass 'i_like_this_place'

  if $("#promo_tabs").length > 0
    hash = location.hash.replace(/#?(\w+)/, "$1")
    $(".tab_content").hide()
    available_hashes = $('.tab_content').map () -> 
	    $(this).attr('id')
    if hash in available_hashes
      showHash.call @, hash
    else
      showHash.call @, available_hashes[0]

  if $('#promo_tabs').length > 0
	  $('#promo_tabs a').on 'click', ->
	  	showHash.call @, $(this).attr('href'), yes

	showHash = (hashName, stripNeed = no) ->
    hashName = hashName.slice(1) if stripNeed
    $("a[href=##{hashName}]").parent().addClass('active').siblings().removeClass('active')
    $("##{hashName}").show().siblings('.tab_content').hide()  
