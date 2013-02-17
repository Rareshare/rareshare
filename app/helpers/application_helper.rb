module ApplicationHelper
  def linkedin_sign_in_button
    link_to user_omniauth_authorize_path(:linkedin), class: "btn btn-large btn-info" do
      content_tag(:i, "", class: "icon-linkedin") + " Sign in with LinkedIn"
    end
  end

  def nav_category(nav_category)
    @nav_category = nav_category
  end

  def nav_link(name, url, opts={})
    active = @nav_category == name || opts[:controller] == self.controller.controller_name || current_page?(url)

    content_tag(:li, class: active ? "active" : "") do
      icon = opts[:icon] ? content_tag(:i, "", class: "icon-#{opts[:icon]}") : ""
      link_to icon + name, url
    end
  end

  def share_a_tool_path(params={})
    current_user.tools_count.to_i > 0 ? tools_path(params) : new_tool_path(params)
  end

  def lease_state(lease)
    content_tag(:span, class: "label label-#{label_class_for(lease)}") { lease.state }
  end
end
