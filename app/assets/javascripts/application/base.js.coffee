jQuery ->
  $("input.date").pickadate(date_min: true)

  $('a[data-toggle="tab"]').on 'shown', (e) ->
    window.location.hash = $(e.target).attr("href")

  tabs = $('.nav-tabs')
  if window.location.hash and tabs.length > 0
    tabs.find("a[href='#{window.location.hash}']").tab('show')

  $("input[data-provide='typeahead']").typeahead
    items: 300 # Unlimited
    source: (query, process) ->
      typeaheadPath = this.$element.data("lookup")
      $.get typeaheadPath, q: query, (resp) ->
        process(resp)
