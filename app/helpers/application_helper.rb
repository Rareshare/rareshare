module ApplicationHelper
  def linkedin_sign_in_button
    link_to user_omniauth_authorize_path(:linkedin), class: "btn btn-large btn-info" do
      content_tag(:i, "", class: "icon-linkedin") + " Sign in with LinkedIn"
    end
  end

  def nav_link(name, url, opts={})
    content_tag(:li, class: current_page?(url) ? "active" : "") do
      icon = opts[:icon] ? content_tag(:i, "", class: "icon-#{opts[:icon]}") : ""
      link_to icon + name, url
    end
  end

  def with_navbar(category, &block)
    
  end
end
