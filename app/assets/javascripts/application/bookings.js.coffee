window.valuePresent = (o) -> o? and typeof(o) is "string" and o isnt ""

window.Booking = (input) ->
  this[k] = ko.observable(v) for k, v of input

  @use_user_address.writeable = ko.computed
    read:  ()    => @use_user_address()
    write: (val) => @use_user_address(val is "1")

  # ko.computed () =>
  #   console.log "transit", @sample_transit(), @sample_transit() == 'rareshare_send', @use_user_address()

  @stepOneComplete   = ko.computed () => valuePresent(@sample_description()) and valuePresent(@sample_deliverable())
  @stepTwoComplete   = ko.computed () => valuePresent(@sample_transit()) and valuePresent(@sample_disposal())
  @stepThreeComplete = ko.computed () => @tos_accepted()

  @canSubmit = ko.computed () =>
    @stepOneComplete() and @stepTwoComplete() and @stepThreeComplete()

  this

$ ->
  ko.bindingHandlers.wysihtml5 =
    init: (element, valueAccessor, allBindingsAccessor, viewModel, bindingContext) ->
      editor = $(element).data("wysihtml5").editor
      observable = valueAccessor()
      editor.on "change", () -> observable @getValue()
