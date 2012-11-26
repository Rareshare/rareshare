module UsersHelper

  def label_class_for(lease)
    {
      pending: "info",
      cancelled: "important",
      confirmed: "success",
      complete: "default"
    }[lease.state.to_sym]
  end

end