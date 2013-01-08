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
    console.log $(this).attr('href'), currentPath, languagePool
    for language in languagePool
      /^\/en\//
      regexp = new RegExp('\^'+ (language.replace /\//g, '\\/') )
      currentPath = currentPath.replace(regexp, '')
    window.location.href = (window.location.host + languageToSet + currentPath).replace /\/{2,}/g, '/'
    
    