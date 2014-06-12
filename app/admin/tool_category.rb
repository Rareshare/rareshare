ActiveAdmin.register ToolCategory do
  index do
    column :id
    column :name
    actions
  end

  form do |f|
    f.inputs "Show Details" do
      f.input :name
    end
    f.actions
  end
end
