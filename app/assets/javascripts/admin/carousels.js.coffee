jQuery ->
  if $("#carousel_resource_id")[0]
    window.availableTools = []
    window.availableBookings = []

    Resource = (label, id) ->
      @label = label
      @id = id

    $.ajax
      url: '/admin/carousels/get_tools.json'
      dataType: 'json'
      success: (data) ->
        for tool in data
          window.availableTools.push(new Resource(tool.display_name, tool.id))
          window.carousel.availableResources.push(new Resource(tool.display_name, tool.id))

    $(document).on "change", "input[name='carousel[resource_type]']", ->
      if this.value == 'Tool'
        window.carousel.availableResources.removeAll()

        for tool in window.availableTools
          window.carousel.availableResources.push(tool)