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
    active = if @nav_category
      @nav_category == name
    elsif opts[:controller]
      opts[:controller] == self.controller.controller_name
    else
      current_page?(url)
    end

    content_tag(:li, class: active ? "active" : "") do
      icon = opts[:icon] ? glyph(opts[:icon]) : ""
      link_to icon + name, url
    end
  end

  def glyph_text(*args)
    args.map do |arg|
      arg.is_a?(Symbol) ? glyph(arg) : arg
    end.join(" ").html_safe
  end

  def share_a_tool_path(params={})
    current_user.tools_count.to_i > 0 ? tools_path(params) : new_tool_path(params)
  end

  def booking_state(booking)
    content_tag(:span, class: "label label-#{label_class_for(booking)}") { booking.state }
  end

  def label_class_for(booking)
    {
      pending: "info",
      cancelled: "important",
      finalized: "success",
      confirmed: "default",
      complete: "default"
    }[booking.state.to_sym]
  end

  def unread_message_count(user)
    count = user.unread_message_count
    badge_type = count > 0 ? "badge-info" : "badge-default"
    content_tag :span, count.to_s, class: "badge #{badge_type}"
  end

  def page_link_to(title, opts={})
    page_title = opts[:page] || title
    slug = Page.where(title: page_title).first.try(:slug)
    link_to title, ( slug.present? ? page_path(slug) : "#" ), opts
  end

  def avatar_of(user)
    link_to user_path(user) do
      image = if user.avatar.present?
        image_tag user.avatar.url(:thumb), class: "avatar"
      else
        content_tag :i, nil, class: "avatar icon-user"
      end

      image + content_tag(:p, user.display_name, style: "text-align: center", class: "small")
    end
  end

  def actionable?(booking)
    can?(:confirm, booking) || can?(:deny, booking) || can?(:finalize, booking)
  end

  def classes_for_booking_row(b)
    who = b.owner?(current_user) ? "info" : ""
    what = actionable?(b) ? "actionable" : ""

    [ who, what ].join(" ")
  end

  def polymorphic_name_of(crumb)
    [ :display_name, :name, :title ].each do |attr|
      return crumb.send(attr) if crumb.respond_to?(attr)
    end
    nil
  end

  def breadcrumb_for(crumb)
    if crumb.is_a?(Array)
      crumb
    elsif crumb == :root
      [ "Home", root_path ]
    elsif crumb == :inbox
      [ "Inbox", messages_path ]
    elsif crumb == :calendar
      [ "Calendar", calendar_path ]
    elsif crumb == :search
      [ "Find a Tool", search_path ]
    elsif crumb.is_a?(ActiveModel::Naming)
      [ "All #{crumb.model_name.pluralize}", url_for(crumb) ]
    elsif name = polymorphic_name_of(crumb)
      [ name, url_for(crumb) ]
    else
      raise "Can't construct breadcrumb from #{crumb}"
    end
  end

  def breadcrumbs(*crumbs)
    divider = content_tag :span, class: :divider do
      content_tag(:i, "", class: "icon-double-angle-right")
    end

    content_tag :ul, class: "breadcrumb" do
      crumbs.map.with_index do |crumb, i|
        if i == crumbs.length - 1
          content_tag :li, class: "active" do
            title, url = breadcrumb_for(crumb)
            content_tag(:span, title)
          end
        else
          content_tag :li do
            title, url = breadcrumb_for(crumb)
            link_to(title, url) + divider
          end
        end
      end.join.html_safe
    end
  end


end
