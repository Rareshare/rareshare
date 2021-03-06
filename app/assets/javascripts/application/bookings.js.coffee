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

  if input.tool_price?
    @default_selected_tool_price = input.tool_price

    if input.tool.price_type == 'sample'
      @tool_price(new window.PerSampleToolPrice(input.tool_price))
    else
      @tool_price(new window.PerTimeToolPrice(input.tool_price))

  @tool = new window.Tool(input.tool)

  @money = (valueAccessor) =>
    ko.computed () =>
      accounting.formatMoney(valueAccessor(), @currency_symbol()) if valueAccessor()?

  @tool_price_value = ko.computed () =>
    if @tool_price?
      if @expedited()
        @tool_price().expedite_amount()
      else
        if @tool.price_type() == 'sample'
           @tool_price().base_amount()
        else
          @tool_price().amount_per_time_unit()

  @tool_price_setup_value = ko.computed () =>
    if @tool_price? and @tool_price().requires_setup and @tool_price().requires_setup()
      @tool_price().setup_price()

  @tool_price_visible  = ko.computed () =>
    returnValue = @money(@tool_price_value)() + ' per sample'
    if @tool_price_setup_value()?
      returnValue += ', ' + @money(@tool_price_setup_value)() + ' setup fee'
    returnValue

  if input.tool.price_type == 'sample'
    @tool_price_subtype  = ko.computed () => @tool_price? and @tool_price().subtype()
    @tool_price_days     = ko.computed () => @tool_price? and @tool_price().lead_time_days()
  else
    @tool_price_subtype = undefined

  @tool_price_expedite = ko.computed () => @tool_price? and @tool_price().can_expedite()
  @tool_price_id       = ko.computed () => @tool_price? and @tool_price().id()
  @tool_price_setup    = ko.computed () => @tool_price? and @tool_price().setup_price()

  @price_units_only = ko.computed () =>
    ( parseFloat(@tool_price_value()) * parseFloat(@units()) ) + parseFloat(@tool_price_setup())
  # NOTE: This is used only for display purposes, and never used to charge the user.
  @final_price = ko.computed () =>
    @price_units_only() + parseFloat(@edits_price()) + parseFloat(@shipping_rate()) + parseFloat(@rareshare_fee()) + parseFloat(@payment_fee())

  this

$ ->
  $('span[data-date-utc]').each ->
    $(this).text "#{moment.utc($(this).data('date-utc')).local().format('MMMM D, YYYY h:mm a')} #{jstz.determine().name()}"

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
