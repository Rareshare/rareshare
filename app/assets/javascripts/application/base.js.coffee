jQuery ->
  $("a[rel~=popover], .has-popover").popover()
  $("a[rel~=tooltip], .has-tooltip").tooltip()
  $(".tip").tooltip().click (evt) -> evt.preventDefault()

  $("input.date").each () ->
    elt = $(this)
    data = elt.data()

    min = if data["min"]? then new Date(data["min"]) else null
    max = if data["max"]? then new Date(data["max"]) else null

    elt.pickadate min: min, max: max
    elt.nextAll(".add-on").click (evt) ->
      elt.pickadate('open')
      evt.stopPropagation()
      evt.preventDefault()

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

  $("form textarea").not("[readonly]").not(".plain").each () ->
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

  $("input.tags").each () ->
    $(this).select2 tags: $(this).data("tags").split(",")
