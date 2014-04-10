ActiveAdmin.register Carousel do
  index do
    column :resource_type
    column :resource_id
    column :external_link_url
    column :external_link_text
    column :custom_content
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