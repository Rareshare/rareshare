window.SampleSize = (input) ->
  this[k] = ko.observable(v) for k, v of input

  @unitName = ko.computed () =>
    @unit()
    $("select#tool_sample_size_unit_id option:selected").text()

  this

window.Tool = (input) ->
  this[k] = ko.observable(v) for k, v of input

  @images = ko.observableArray(input.images)
  @sampleSize = new SampleSize(input.sample_size)

  @showFacility = ko.computed () =>
    @facility_id() is "" or @facility_id() is null

  @currencySymbol = ko.computed () =>
    if @currency() is "USD" then "$" else "£"

  @requiresAccessNotes = ko.computed () =>
    @access_type() is "partial"

  @addFile = (tool, evt) =>
    uploadUrl = $(evt.currentTarget).data("upload")
    filepicker.pick (blob) =>
      req = $.ajax
        url: uploadUrl
        type: 'post'
        data:
          file:
            name: blob.filename
            url: blob.url
            size: blob.size
            content_type: blob.mimetype

      req.done (file) =>
        if @images().map((i) -> i.file_id).indexOf(file.id) is -1
          @images.push(file_id: file.id, thumbnail: file.thumbnail, id: null)

  @removeFile = (image, evt) =>
    console.log "target", evt.currentTarget, $(evt.currentTarget).closest("li")
    @images.destroy image
    root = $(evt.currentTarget).closest("li")
    root.hide()
    root.find("input.destroyed").val("1")

  @samples_in_bulk_run = ko.computed () =>
    [ runs, samples_per_run ] = [ @bulk_runs(), @samples_per_run() ]
    unless ( runs? and samples_per_run? ) then return null

    runs * samples_per_run

  @toolPriceCollection = new ToolPriceCollection(input)

  this

window.ToolPriceCollection = (input) ->
  @toolPrices  = ko.observableArray()

  @appendPrice = ()      => if @canAddPrice() then @toolPrices.push(new ToolPrice({}, this))
  @removePrice = (price) => () => @toolPrices.destroy(price)
  @priceTypes  = ko.observableArray(input.tool_price_categories)

  @canAddPrice = ko.computed () =>
    validOrDestroyed = (acc, obj) -> acc and (obj._destroy || obj.isValid())
    @toolPrices().reduce validOrDestroyed, true

  @selectedPrices = ko.computed () =>
    toolPrice.subtype() for toolPrice in @toolPrices()

  for price in input.tool_prices
    @toolPrices.push(new ToolPrice(price, this))

  this

window.ToolPrice = (input, collection) ->
  this[k] = ko.observable(v) for k, v of input

  @selectablePriceTypes = ko.computed () =>
    if !collection? then return []

    for price in collection.priceTypes()
      [ label, id ] = price
      if collection.selectedPrices().indexOf(id) >= 0 and id isnt @subtype() then continue
      { label: price[0], id: price[1] }

  @isValid = ko.computed () =>
    @subtype()? and @base_amount()? and @lead_time_days()?

  @should_expedite = ko.observable(false)

  @visible_price = ko.computed () =>
    if @should_expedite() then @expedite_price() else @base_price()

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

  # Necessary for managing typeahead clicks.
  ko.bindingHandlers.typeahead =
    init: (elt, val, all, vm) ->
      if ( typeahead = $(elt).data("typeahead") ) and ( button = $(elt).nextAll("button") )
        button.click (evt) ->
          evt.preventDefault()
          typeahead.query = ""
          items = typeahead.source("*", $.proxy(typeahead.process, typeahead))
          if items? then typeahead.process(items)
          # Without this, menu disappears on mouse move.
          typeahead.$menu.off("mouseleave", "li")

  ko.bindingHandlers.btnEnable =
    update: (elt, val, all, vm) ->
      predicate = ko.utils.unwrapObservable(val())
      $(elt).attr 'disabled', !predicate

  # Bind automatically to add remote form submit support.
  ko.bindingHandlers.remote =
    init: (elt, val, all, vm) ->
      $(elt).on "submit", () ->

