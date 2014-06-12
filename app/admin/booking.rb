ActiveAdmin.register Booking do
  index do
    selectable_column
    column :id
    column :owner
    column :renter
    column :state
    column :deadline
    column :price
    actions
  end

  show do
    panel "History" do
      content_tag(:ol) do
        booking.booking_logs.each do |log|
          concat(content_tag(:li, "#{log.updated_by.display_name}
                                  #{log.state_transition_description} on #{log.created_at.to_s(:long)}"))
        end
      end
    end

    default_main_content
  end

  filter :id
  filter :state

  # See permitted parameters documentation:
  # https://github.com/gregbell/active_admin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # permit_params :list, :of, :attributes, :on, :model
  #
  # or
  #
  # permit_params do
  #  permitted = [:permitted, :attributes]
  #  permitted << :other if resource.something?
  #  permitted
  # end

end
