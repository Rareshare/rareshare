$ -> 
  $("input[name='tool[price_per_hour]']").change ->
    val = parseFloat($(this).val())
    console.log val
    console.log $(this).next(".help-block").find(".price_per_day")
    $(this).next(".help-block").find(".price_per_day").text(val * 8.0)