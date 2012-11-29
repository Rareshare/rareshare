$ -> 
  $("input[name='tool[price_per_hour]']").change ->
    val = parseFloat($(this).val())
    $(this).next(".help-block").find(".price_per_day").text(val * 8.0)
