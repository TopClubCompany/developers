$ ->
  if $('#product_company_id')[0]
    $c_id = $('#product_company_id')
    $av_ids = $('#av_company_ids')
    $av_ids.data('all', $av_ids.val())
    $c_id.change ->
      c_id = $c_id.val()
      if c_id
        $av_ids.val(c_id)
      else
        $av_ids.val($av_ids.data('all'))