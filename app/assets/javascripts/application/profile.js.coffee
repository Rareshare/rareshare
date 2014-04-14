window.Profile = (input) ->
  this[k] = ko.observable(v) for k, v of input

  @keywordField = $("#enter_keyword")
