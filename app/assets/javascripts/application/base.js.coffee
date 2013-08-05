jQuery ->
  $(".tip").tooltip().click (evt) -> evt.preventDefault()

  $("input.date").each () ->
    min = new Date($(this).data("min"))
    $(this).pickadate min: min

  $('a[data-toggle="tab"]').on 'shown', (e) ->
    window.location.hash = $(e.target).attr("href")

  $("input[data-provide='typeahead']").typeahead
    items: 300 # Unlimited
    source: (query, process) ->
      typeaheadPath = this.$element.data("lookup")
      $.get typeaheadPath, q: query, (resp) ->
        process(resp)

  $("body").click (evt) ->
    $("input[data-provide='typeahead']").each ->
      $(this).data('typeahead').hide()

  $("form textarea:not([readonly])").each () ->
    $(this).wysihtml5(link: false, lists: false, image: false)

  $("[data-toggle='confirm']").click (evt) ->
    evt.preventDefault()

    button = $(this)
    form = button.closest("form")
    modal  = $("#modalConfirm")

    if form.find(".commit").length is 0
      form.prepend $("<input />").attr(type: "hidden", name: "commit", class: "commit")
    form.find(".commit").val button.attr("value")

    commitType = button.attr("name")
    modal.find(".modal-header h3").text button.data("title")
    modal.find("button.btn-primary").off("click").on "click", () -> form.trigger "submit", commit: commitType

    modal.modal()
