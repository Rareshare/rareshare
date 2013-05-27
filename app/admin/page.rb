ActiveAdmin.register Page do
  index do
    column :title
    column :slug
    default_actions
  end

  form do |f|
    f.inputs "Show Details" do
      f.input :title
      f.input :slug, hint: "Optional - will be generated as needed"
      f.input :content, as: :text
    end
    f.actions
  end
end
