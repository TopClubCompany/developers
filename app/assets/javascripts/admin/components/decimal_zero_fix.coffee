$ ->
  _.each $(".numeric.decimal"), (el) =>
    $el = $(el)
    val = parseFloat($el.val()).toString().split(".")
    val[1] = val[1]+"0" if val[1].length < 2
    $(el).val(val.join("."))
