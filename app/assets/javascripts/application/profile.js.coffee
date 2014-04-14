window.Profile = (input) ->
  this[k] = ko.observable(v) for k, v of input
  @currentSkill = undefined
  @skillField = $(".dynamic-text-field")
  @skillsTags = ko.observableArray(input.skills_tags)

  for skill in @skillsTags()
    console.log skill


  @saveSkill = () =>
    skill = @skillField.val()

    unless skill.trim() == ""
      # if it's a new word
      if @skillsTags().indexOf(skill) == -1
        if @currentSkill
          @skillsTags.replace(@currentSkill, skill)
          @currentSkill = undefined
        else
          @skillsTags.push(skill)

      @skillField.val("")
      @skillField.trigger('focus')

  @editSkill = (skill) =>
    @skillField.val(skill)
    @skillField.trigger('focus')
    @currentSkill = skill

  @removeSkill = (skill) =>
    @skillsTags.remove(skill)

  this
$ ->
  $(".dynamic-text-field").keydown (event) ->
    if event.keyCode == 13
      event.preventDefault()

  $(".dynamic-text-field").keyup (event) ->
    if event.keyCode == 13
      event.preventDefault()
      $(".dynamic-save-button").click()
      console.log 'yea'