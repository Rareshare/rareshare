$ ->
  $("#profile form.welcome").each () ->
    ko.applyBindings tos_accepted: ko.observable(false)
