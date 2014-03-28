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

  @deadline = ko.observable new Date(input.deadline)

  @money = (valueAccessor) =>
    ko.computed () =>
      accounting.formatMoney(valueAccessor(), @currency_symbol()) if valueAccessor()?


  if input.tool_price? then @tool_price(new window.ToolPrice(input.tool_price))

  # Using a null object might be preferable to this.
  @tool_price_visible  = ko.computed () =>
    @tool_price()? and
      if @expedited() then @tool_price().expedite_amount() else @tool_price().base_price()

  @tool_price_subtype  = ko.computed () => @tool_price()? and @tool_price().subtype()
  @tool_price_days     = ko.computed () => @tool_price()? and @tool_price().lead_time_days()
  @tool_price_id       = ko.computed () => @tool_price()? and @tool_price().id()
  @tool_price_setup    = ko.computed () => @tool_price()? and @tool_price().setup_price()
  @tool_price_expedite = ko.computed () => @tool_price()? and @tool_price().can_expedite()

  @tool = new window.Tool(input.tool)

  # NOTE: This is used only for display purposes, and never used to charge the user.
  @final_price = ko.computed () =>
    ( parseFloat(@tool_price_visible()) * parseFloat(@samples()) ) + parseFloat(@tool_price_setup()) + parseFloat(@shipping_rate()) + parseFloat(@rareshare_fee())

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

  ko.bindingHandlers.textMoney =
    update: (element, valueAccessor, allBindingsAccessor, viewModel, bindingContext) ->
      console.log "accessor", valueAccessor
      [ observable, currency ] = if ko.isObservable(valueAccessor())
        [ ko.utils.unwrapObservable(valueAccessor()), "$" ]
      else
        [ ko.utils.unwrapObservable(valueAccessor().value), ko.utils.unwrapObservable(valueAccessor().currency) ]

      console.log "observable", observable, "currency", currency

      $(element).text accounting.formatMoney(observable, currency)
