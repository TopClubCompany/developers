$ ->
  $("small.created_time_ago").timeago()
  $(".upload_avatar").live 'click', (e) =>
    e.preventDefault()
    $("input[type=file]").click()