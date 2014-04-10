ActiveAdmin.register Carousel do
  index do
    column :resource_id
    column :image
    column :active
    default_actions
  end

  form :partial => "form"

  collection_action :get_tools, method: :get do
    @tools = Tool.live
    respond_with @tools.select(&:id).as_json(only: [:id], methods: [:display_name], minimal: true)
  end
end