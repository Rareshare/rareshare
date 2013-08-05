window.valuePresent = (o) -> o? and typeof(o) is "string" and o isnt ""

window.Booking = (input) ->
  this[k] = ko.observable(v) for k, v of input

  @use_user_address.writeable = ko.computed
    read:  ()    => @use_user_address()
    write: (val) => @use_user_address(val is "1")

  @stepOneComplete   = ko.computed () => valuePresent(@sample_description()) and valuePresent(@sample_deliverable())
  @stepTwoComplete   = ko.computed () => valuePresent(@sample_transit()) and valuePresent(@sample_disposal())
  @stepThreeComplete = ko.computed () => @tos_accepted()

  @canSubmit = ko.computed () =>
    @stepOneComplete() and @stepTwoComplete() and @stepThreeComplete()

  @shipping_rate = ko.computed () =>
    @shipping_service()?.rate || 0.00

  # NOTE: This is used only for display purposes, and never used to charge the user.
  @final_price = ko.computed () =>
    parseFloat(@price()) + parseFloat(@shipping_rate()) + parseFloat(@rareshare_fee())

  @deadline = ko.observable new Date(input.deadline)

  @money = (valueAccessor) =>
    ko.computed () =>
      accounting.formatMoney(valueAccessor(), @currency_symbol())

  ko.computed () =>
    baseUrl = "/tools/#{@tool().id}/pricing"
    console.log "retrieving for", @deadline(), @samples()
    $.get baseUrl, date: @deadline().toJSON(), samples: @samples(), (resp) =>
      console.log "pricing", resp.pricing
      @est_must_expedite resp.pricing.must_expedite
      @est_runs_required resp.pricing.runs_required
      @est_price_per_run resp.pricing.price_per_run
      @est_total_price   resp.pricing.total_price
      @must_expedite     resp.pricing.must_expedite
      @must_bulkify      resp.pricing.must_bulkify


  @est_must_expedite = ko.observable(false)
  @est_runs_required = ko.observable(1)
  @est_price_per_run = ko.observable()
  @est_total_price   = ko.observable()
  @must_expedite     = ko.observable(false)
  @must_bulkify      = ko.observable(false)

  this

$ ->
  ko.bindingHandlers.wysihtml5 =
    init: (element, valueAccessor, allBindingsAccessor, viewModel, bindingContext) ->
      editor = $(element).data("wysihtml5").editor
      observable = valueAccessor()
      editor.on "change", () -> observable @getValue()

  ko.bindingHandlers.pickadate =
    init: (element, valueAccessor, allBindingsAccessor, viewModel, bindingContext) ->
      settings = valueAccessor()

      $(element).pickadate()
      picker = $(element).pickadate 'picker'

      picker.set 'select', settings.value()

      if settings.min? then picker.set 'min', settings.min

      picker.on 'set', (val) ->
        date = new Date(val.select)
        settings.value(date)
