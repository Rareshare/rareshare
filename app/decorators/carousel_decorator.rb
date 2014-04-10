class CarouselDecorator < Draper::Decorator
  delegate_all

  def link_url
    if resource_present?
      h.send("#{resource_type.downcase}_path".to_sym, resource_id)
    elsif external_link_present?
      external_link
    elsif custom_content.present?
      "#carousel-modal"
    end
  end

  def link_text
    if resource_present?
      resource.display_name
    elsif external_link_present?
      external_link_title
    elsif custom_content.present?
      "About this image"
    end
  end

  def link
    if resource_present?
      h.link_to(link_text, link_url)
    elsif external_link_present?
      h.link_to(link_text, link_url, target: "_blank")
    elsif custom_content.present?
      h.link_to(link_text, link_url, "data-toggle" => "modal")
    end
  end
end
