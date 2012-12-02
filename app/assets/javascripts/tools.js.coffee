$ -> 
  $("input[name='tool[price_per_hour]']").change ->
    val = parseFloat($(this).val())
    $(this).next(".help-block").find(".price_per_day").text(val * 8.0)

  targetSlider = $("#new_tool .slider-input")
  minSize = $("#new_tool #tool_sample_size_min")
  maxSize = $("#new_tool #tool_sample_size_max")
  helpBlock = targetSlider.next(".help-block")
  
  updateVisualRange = () ->
    helpBlock.find(".text-min").text minSize.val()
    helpBlock.find(".text-max").text maxSize.val()

  targetSlider.slider({
    range: true,
    min: -9,
    max: 6,
    values: [minSize.val(), maxSize.val()]
    slide: (evt, ui) ->
      minSize.val(ui.values[0])
      maxSize.val(ui.values[1])
      updateVisualRange()
  })

  updateVisualRange()
