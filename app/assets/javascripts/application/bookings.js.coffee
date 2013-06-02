window.valuePresent = (o) -> o? and typeof(o) is "string" and o isnt ""

window.Booking = (input) ->
  this[k] = ko.observable(v) for k, v of input

  @stepOneComplete   = ko.computed () => valuePresent(@sample_description())
  @stepTwoComplete   = ko.computed () => valuePresent(@sample_deliverable())
  @stepThreeComplete = ko.computed () => valuePresent(@sample_transit())
  @stepFourComplete  = ko.computed () => @tos_accepted()

  @canSubmit = ko.computed () =>
    @stepOneComplete() and @stepTwoComplete() and @stepThreeComplete() and @stepFourComplete()

  @needsAddress = ko.computed () => !parseInt(@address_id(), 10) # NaN is falsy in Coffee

  this

$ ->
  ko.bindingHandlers.wysihtml5 =
    init: (element, valueAccessor, allBindingsAccessor, viewModel, bindingContext) ->
      editor = $(element).data("wysihtml5").editor
      observable = valueAccessor()
      editor.on "change", () -> observable @getValue()
