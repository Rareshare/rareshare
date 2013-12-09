window.Questions = (input) ->
  input ||= {}

  @collection = collection = ko.observableArray(input.questions || [])
  console.log input.questions

  Question = () ->
    @topic = ko.observable()
    @body = ko.observable()
    @submitting = ko.observable(false)

    @valid = ko.computed () =>
      !@submitting() and @topic()? and @topic() != "" and @body()? and @body() != ""

    @save = (form) =>
      console.log "valid", @valid()
      if @valid()
        form = $(form)
        @submitting true
        req = $.post form.attr("action"), form.serialize()

        req.done (question) =>
          collection.push question
          @clear()

    @clear = () =>
      @topic("")
      @body(null)
      @submitting false

    return this

  @newQuestion = new Question()

  return this
