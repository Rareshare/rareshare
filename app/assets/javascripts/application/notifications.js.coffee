NotificationUpdater = () ->
  @notifications = ko.observableArray()
  @unseen        = ko.computed () => (n for n in @notifications() when n.seen isnt true).length
  @isEmpty       = ko.computed () => @notifications().length is 0

  @update = () =>
    $.get("/notifications.json").done (resp) =>
      @notifications resp.notifications

  setInterval @update, 10000
  @update()

  return this

$ ->
  ko.applyBindings { updater: new NotificationUpdater() }, $("li.notifications")[0]
