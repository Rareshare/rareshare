window.SampleSize = (input) ->
  this[k] = ko.observable(v) for k, v of input

  @unit.writeable = ko.computed
    read: () -> ""
    write: (val) =>
      unless val is ""
        $.get "/units/#{val}", (resp) => @unit resp

  @unitName = ko.computed () => @unit()?.display_name

  this

window.Tool = (input) ->
  this[k] = ko.observable(v) for k, v of input

  @images = ko.observableArray(input.images)
  @sampleSize = new SampleSize(input.sample_size)

  @currencySymbol = ko.computed () =>
    if @currency() is "USD" then "$" else "£"

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


