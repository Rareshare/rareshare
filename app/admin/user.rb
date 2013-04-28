ActiveAdmin.register User do
  index do
    column :first_name
    column :last_name
    column :email
    column :current_sign_in_at
    column :last_sign_in_at
    column :sign_in_count
    default_actions
  end

  filter :email

  form do |f|
    f.inputs "User Details" do
      f.input :last_name
      f.input :first_name
      f.input :email
      f.input :admin, hint: "Is user admin? Handle with care."
      f.input :confirmed_at, as: :datetime, hint: "Override this to allow users access without email confirmation."
    end

    f.inputs "Bio" do
      f.input :title
      f.input :education
      f.input :organization
      f.input :bio, as: :html_editor
      f.input :qualifications, as: :html_editor
    end
    f.actions
  end
end
