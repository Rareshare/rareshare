module UsersHelper

  def label_class_for(booking)
    {
      pending: "info",
      cancelled: "important",
      confirmed: "success",
      complete: "default"
    }[booking.state.to_sym]
  end

end
