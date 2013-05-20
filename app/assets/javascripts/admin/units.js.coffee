$ ->
  $('table.units').each () ->
    $(this).find('tr').each () ->
      checkbox = $(this).find("input[type=checkbox]")

      $(this).click (evt) -> checkbox.click()

      checkbox.click (evt) ->
        evt.stopPropagation()

        form = checkbox.closest("form")
        action = form.attr("action")

        $.post(action, form.serialize()).success (resp) ->
          console.log resp
