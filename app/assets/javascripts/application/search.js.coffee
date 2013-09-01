$ ->
  form = $("form.new_requested_search")

  form.on "ajax:success", (resp, data) -> $(this).text data.text
