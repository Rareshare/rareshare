# encoding: utf-8
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

  def active_page?(title)
    controller_name == 'pages' && defined?(@page) && @page.title == title
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
    name_methods = [ :display_name, :name, :title ]

    if crumb.new_record?
      "New #{crumb.class.model_name.human}"
    else
      name_methods.inject(nil) {|o, m| o || crumb.respond_to?(m) && crumb.send(m) }
    end
  end

  def breadcrumb_for(crumb)
    if crumb.is_a?(Array)
      crumb
    elsif crumb.is_a?(String)
      [ crumb, nil ]
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

  def terms_and_conditions
    sanitize Page.where(title: "Terms & Conditions").first.try(:content)
  end

  def currency_for(model)
    raise "No currency" unless model.respond_to?(:currency)
    ( model.currency || "USD" ) == "USD" ? "$" : "£"
  end

  def breadcrumbs(*crumbs)
    divider = content_tag :span, class: :divider do
      content_tag(:i, "", class: "icon-double-angle-right")
    end

    content_tag :ul, class: "breadcrumb" do
      crumbs.map.with_index do |crumb, i|
        title, url = breadcrumb_for(crumb)
        active = ( i == crumbs.length - 1 )

        link = if active || url.blank?
          content_tag(:span, title)
        else
          link_to(title, url)
        end

        link += divider unless active

        content_tag :li, link, class: active ? "active" : ""
      end.join.html_safe
    end
  end

  def page_header(title, opts={})
    if opts[:updated_at]
      opts[:subtitle] = "Last edited on #{opts[:updated_at].to_s(:long)}"
    elsif opts[:confirmed_at]
      opts[:subtitle] = "Joined on #{opts[:confirmed_at].to_date.to_s(:long)}"
    end

    opts[:subtitle] ||= "&nbsp;".html_safe

    render partial: "shared/page_header", locals: opts.merge(title: title)
  end

  def filepicker_js_snippet
    <<-JS
      (function(a){if(window.filepicker){return}var b=a.createElement("script");b.type="text/javascript";b.async=!0;b.src=("https:"===a.location.protocol?"https:":"http:")+"//api.filepicker.io/v1/filepicker.js";var c=a.getElementsByTagName("script")[0];c.parentNode.insertBefore(b,c);var d={};d._queue=[];var e="pick,pickMultiple,pickAndStore,read,write,writeUrl,export,convert,store,storeUrl,remove,stat,setKey,constructWidget,makeDropPane".split(",");var f=function(a,b){return function(){b.push([a,arguments])}};for(var g=0;g<e.length;g++){d[e[g]]=f(e[g],d._queue)}window.filepicker=d})(document);
      (function(fp) { fp.setKey("#{ENV['FILEPICKER_API_KEY']}") })(window.filepicker);
    JS
  end

  def google_maps_address_for(address)
    formatted_address = address_for_map(address)
    raw("//maps.google.com/maps?f=q&q=#{formatted_address}&source=s_q&hl=en&geocode=&aq=&ie=UTF8&spn=0.706779,1.187897&t=m&z=10&output=embed")
  end

  def address_for_map(address)
    address.gsub(/,\s,/, ',').gsub(/\s/, '+').gsub(/#/, '%23')
  end
end
