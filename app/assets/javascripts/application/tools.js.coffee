window.SampleSize = (input) ->
  this[k] = ko.observable(v) for k, v of input

  @unit.writeable = ko.computed
    read: () -> ""
    write: (val) =>
      unless val is ""
        $.get "/units/#{val}", (resp) => @unit resp

  @unitName = ko.computed () => console.log(@unit()); @unit().display_name

  this

window.Tool = (input) ->
  this[k] = ko.observable(v) for k, v of input

  @sampleSize = new SampleSize(input.sample_size)

  @currencySymbol = ko.computed () =>
    if @currency() is "USD" then "$" else "£"

  this

$ ->
  ko.bindingHandlers.slider =
    init: (elt, val, all, vm) ->
      sampleSize = val()
      sizes = sampleSize.all()
      $(elt).slider
        range: true
        min: sizes[0].exponent
        max: sizes[sizes.length - 1].exponent
        values: [ sampleSize.min(), sampleSize.max() ]
        slide: (evt, ui) ->
          sampleSize.min ui.values[0]
          sampleSize.max ui.values[1]

  # Necessary for managing typeahead clicks. Replace with select2.
  ko.bindingHandlers.typeahead =
    init: (elt, val, all, vm) ->
      if ( typeahead = $(elt).data("typeahead") ) and ( button = $(elt).nextAll("button") )
        button.click (evt) ->
          evt.preventDefault()
          typeahead.query = ""
          items = typeahead.source("*", $.proxy(typeahead.process, typeahead))
          typeahead.process(items) if items?
          typeahead.$menu.off("mouseleave", "li") # Without this, menu disappears on mouse move.
