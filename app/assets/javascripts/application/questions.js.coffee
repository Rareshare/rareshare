window.Questions = (input) ->
  input ||= {}

  Question = () ->
    @topic = ko.observable()
    @body = ko.observable()
    @submitting = ko.observable(false)

    @valid = ko.computed () =>
      !@submitting() and @topic()? and @topic() != "" and @body()? and @body() != ""

    @save = (form) =>
      if @valid()
        form = $(form)
        @submitting true
        req = $.post form.attr("action"), form.serialize()

        req.done (question) =>
          collection.push question
          @clear()

    @clear = () =>
      @topic ""
      @body null
      @submitting false

    return this

  QuestionResponse = (question) ->
    @body = ko.observable()
    @submitting = ko.observable(false)

    @valid = ko.computed () =>
      !@submitting() and @body()? and @body() != ""

    @save = (form) =>
      console.log "here we are", @valid()
      if @valid()
        form = $(form)
        @submitting true
        req = $.post question.question_reply_path, form.serialize()

        req.done (response) =>
          console.log "we've received response", response
          question.question_responses.push response
          @body null
          @submitting false

    return this

  @newQuestion = new Question()
  rawCollection = for question in (input.questions || [])
    $.extend question,
      newResponse: new QuestionResponse(question),
      question_responses: ko.observableArray(question.question_responses)

  @collection = collection = ko.observableArray(rawCollection)
  console.log rawCollection

  return this
