$ ->
  $("#tools").each () ->
    $(".tool_sample_size").each ->
      $this = $(this)
      targetSlider = $this.find(".slider-input")
      minSize = $this.find("#tool_sample_size_min")
      maxSize = $this.find("#tool_sample_size_max")
      helpBlock = targetSlider.next(".help-block")

      updateVisualRange = () ->
        helpBlock.find(".text-min").text minSize.val()
        helpBlock.find(".text-max").text maxSize.val()

      targetSlider.slider
        range: true,
        min: -9,
        max: 6,
        values: [minSize.val(), maxSize.val()]
        slide: (evt, ui) ->
          minSize.val(ui.values[0])
          maxSize.val(ui.values[1])
          updateVisualRange()

      updateVisualRange()

    $(".input-append").each ->
      input = $(this).find("input")
      button = $(this).find("button")

      typeahead = input.data("typeahead")

      if typeahead
        button.click (evt) ->
          evt.preventDefault()
          typeahead.query = ""
          items = typeahead.source("*", $.proxy(typeahead.process, typeahead))
          typeahead.process(items) if items?
          typeahead.$menu.off("mouseleave", "li") # Without this, menu disappears on mouse move.

    canExpedite = $("input[name='tool[can_expedite]']")
    expeditedFields = $("[id^=tool_expedited]")

    resetExpeditedFields = () ->
      if canExpedite.is(":checked")
        expeditedFields.removeAttr("disabled")
      else
        expeditedFields.attr("disabled", "disabled")

    resetExpeditedFields()
    $("input[name='tool[can_expedite]']").on "change", resetExpeditedFields
