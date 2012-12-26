$ ->
  $datepicker = $('input[name="reserve_date"]')
  if $datepicker.length > 0
    $datepicker.css('zIndex', '2')
    if $datepicker.hasClass('dateFormatNeeded')
      $.datepicker.setDefaults
        dateFormat: 'dd/mm/yy'
    $datepicker.datepicker()
 


      
###

          # $("select[name=reserve_date]").on 'changed', ->
      # date = $(this).val()
      # console.log date
      # headlineText = $('#mapcontainer > h3:first-child').html().replace(/(\d+\/?){3}(?=,)/, date)
      # $('#mapcontainer > h3:first-child').html headlineText
      # self.places.updateDate date

    $("select[name=reserve_time]").on 'change', ->
      time = $(this).val()
      console.log time
      # headlineText = $('#mapcontainer > h3:first-child').html().replace(/\d+\:\d+(?=\sfor\s)/, time)
      # $('#mapcontainer > h3:first-child').html headlineText
      self.places.updateTime time               
    
    $("select[name=number_of_people]").on 'change', ->          
      number = $(this).val()
      headlineText = $('#mapcontainer > h3:first-child').html().replace(/\d+(?=\speople)/, number)
      $('#mapcontainer > h3:first-child').html headlineText
      # self.places.updatePeople number
    
    
###
