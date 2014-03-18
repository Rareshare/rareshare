NotificationUpdater = () ->
  @notifications = ko.observableArray()
  @unseen        = ko.computed () => (n for n in @notifications() when n.seen isnt true).length
  @isEmpty       = ko.computed () => @notifications().length is 0
  @seenIds       = ko.computed () => n.id for n in @notifications()

  @update = () =>
    $.get("/notifications.json").done (resp) =>
      for n in resp.notifications.reverse()
        if @seenIds().indexOf(n.id) < 0
          @notifications.unshift n

  setInterval @update, 10000
  @update()

  return this

$ ->
  notifications = $("li.notifications")[0]

  if notifications?
    ko.applyBindings { updater: new NotificationUpdater() }, notifications
