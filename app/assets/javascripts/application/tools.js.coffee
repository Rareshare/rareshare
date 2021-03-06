window.SampleSize = (input) ->
  this[k] = ko.observable(v) for k, v of input

  @unitName = ko.computed () =>
    @unit()
    $("select#tool_sample_size_unit_id option:selected").text()

  this

window.Tool = (input) ->
  this[k] = ko.observable(v) for k, v of input

  @keywordField = $(".dynamic-text-field")

  @images = ko.observableArray(input.images)
  @documents = ko.observableArray()
  for file in input.documents
    @documents.push(_delete: 0, file_id: file.file_id, name: file.file_name, url: file.file_url, id: file.id)

  @possible_terms_documents = ko.observableArray(input.possible_terms_documents)
  @keywords = ko.observableArray(input.keywords)
  @currentKeyword = undefined

  @sampleSize = new SampleSize(input.sample_size)

  @showFacility = ko.computed () =>
    @facility_id() is "" or @facility_id() is null

  @currencySymbol = ko.computed () =>
    if @currency() is "USD" then "$" else "£"

  @requiresAccessNotes = ko.computed () =>
    @access_type() is "partial"

  @addFile = (tool, evt) =>
    $(evt.currentTarget).next("input[type=file]").click()

  @promptFileUpload = (tool, evt) ->
    $(evt.target).next("input[type=file]").click()

  @removeFile = (image, evt) =>
    root = $(evt.currentTarget).closest("li")
    root.addClass("hide")
    root.find("input.destroyed").val("1")

  @saveKeyword = () =>
    keyword = @keywordField.val()

    unless keyword.trim() == ""
      # if it's a new word
      if @keywords().indexOf(keyword) == -1
        if @currentKeyword
          @keywords.replace(@currentKeyword, keyword)
          @currentKeyword = undefined
        else
          @keywords.push(keyword)

      @keywordField.val("")
      @keywordField.trigger('focus')

  @editKeyword = (keyword) =>
    @keywordField.val(keyword)
    @keywordField.trigger('focus')
    @currentKeyword = keyword

  @removeKeyword = (keyword) =>
    @keywords.remove(keyword)

  @updateTermsDocuments = (doc) =>
    @possible_terms_documents.push doc
    @terms_document_id doc.id

  @updateImageThumbs = (file) =>
    if @images().map((i) -> i.file_id).indexOf(file.id) is -1
      @images.push(file_id: file.id, thumbnail: file.thumbnail, id: null)

  @updateDocumentList = (file) =>
    @documents.push(_delete: 0, file_id: file.id, name: file.name, url: file.file.url, id: null)

  @removeDocument = (file) =>
    newFile = file
    newFile._delete = 1
    @documents.remove(file)
    @documents.push(newFile)

  @perSampleToolPriceCollection = new PerSampleToolPriceCollection(input)
  @perTimeToolPrice = new PerTimeToolPrice(input.per_time_tool_price)
  @sample_delivery_address(input.sample_delivery_address)

#  @facility(input.facility)

#  @selected_facility = ko.computed () =>
#    @facility()
#
  @selected_facility = ko.observable()
  @selected_delivery_facility = ko.observable()

  this

window.FacilityCollection = (input, default_id) ->
  @facilities = ko.observableArray()

  console.log "woo" + input.length
  for facility in input
    if facility.id
      facility_id = facility.id.toString()

      if facility_id == default_id
        @facilities.unshift(new Facility(facility))
      else
        @facilities.push(new Facility(facility))

  this


window.Facility = (input) ->
  this[k] = ko.observable(v) for k, v of input

  @name = "New facility" if @name() == null
#  @address = new Address() if @address() == null
  this

window.Address = () ->


window.PerSampleToolPriceCollection = (input) ->
  @toolPrices  = ko.observableArray()

  emptyToolPrice = input.per_sample_tool_prices[input.per_sample_tool_prices.length - 1]

  @appendPrice = ()      => if @canAddPrice() then @toolPrices.push(new PerSampleToolPrice(emptyToolPrice, this))
  @removePrice = (price) => () => @toolPrices.destroy(price)
  @priceTypes  = ko.observableArray(input.tool_price_categories)

  @priceTypes.unshift(["", null])

  @canAddPrice = ko.computed () =>
    validOrDestroyed = (acc, obj) -> acc and (obj._destroy || obj.isValid())
    @toolPrices().reduce validOrDestroyed, true

  @selectedPrices = ko.computed () =>
    toolPrice.subtype() for toolPrice in @toolPrices()

  for price in input.per_sample_tool_prices
    @toolPrices.push(new PerSampleToolPrice(price, this))

  this

window.PerTimeToolPrice = (input) ->
  this[k] = ko.observable(v) for k, v of input

  @selectablePriceTypes = ko.computed () =>
    if !collection? then return []

    for price in collection.priceTypes()
      [ label, id ] = price
      if collection.selectedPrices().indexOf(id) >= 0 and id isnt @subtype() then continue
      { label: price[0], id: price[1] }

  @isValid = ko.computed () =>
    @amount_per_time_unit()? and @time_unit()?

  @should_expedite = ko.observable(false)

  this

window.PerSampleToolPrice = (input, collection) ->
  this[k] = ko.observable(v) for k, v of input

  console.log "base" + @base_amount()

  @selectablePriceTypes = ko.computed () =>
    if !collection? then return []

    for price in collection.priceTypes()
      [ label, id ] = price
      if collection.selectedPrices().indexOf(id) >= 0 and id isnt @subtype() then continue
      { label: price[0], id: price[1] }

  @isValid = ko.computed () =>
    base_amount_greater_than_zero = @base_amount() > 0
    @subtype()? and @subtype() != "" and base_amount_greater_than_zero

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

  ko.bindingHandlers.fileupload =
    init: (elt, val, all, vm) ->
      loadingModal = $("#loadingModal")
      $(elt).fileupload
        dataType: "json"
        submit: (e, data) ->
          console.log "submit", data
          data.formData = {}

          loadingModal.show()

        done: (e, data) ->
          loadingModal.hide()
          console.log "done", data
          val()(data.result)

