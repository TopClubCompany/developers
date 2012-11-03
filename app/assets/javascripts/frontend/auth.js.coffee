$ ->
  $("#complete_reg").click ->
    email = encodeURIComponent( $("#auth_email").val())
    email = $("#auth_email").val()
    link = $(this).data('url')
    $(location).attr('href', link + '/' + email);