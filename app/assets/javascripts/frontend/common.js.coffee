$ ->
  $("small.created_time_ago").timeago()
  $(".upload_avatar").live 'click', (e) =>
    e.preventDefault()
    $("input[type=file]").click()
  
  languagePool = $('#language a').map (index, el) ->
    $(el).attr('href')
  $('#language a').on 'click', (e) ->
    e.preventDefault()
    languageToSet = $(e.target).attr('href')
    currentPath = window.location.href.toString().split(window.location.host)[1]
    
    for language in languagePool
      regexp = new RegExp('\^'+ (language.replace /\//g, '\\/') )
      currentPath = currentPath.replace(regexp, '')
    console.log currentPath
    if languageToSet == "ru"
      languageToSet = ""
    window.location.replace((languageToSet + currentPath).replace(/\/{2,}/g, '/'))
    
    