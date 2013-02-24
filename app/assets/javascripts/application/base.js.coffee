jQuery ->
  $("input.date").pickadate(date_min: true)

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
