module ToolsHelper
  def sample_size_text(tool)
    <<-HTML.html_safe
      <span class="exponent">10<sup class="text-min">#{tool.sample_size_min}</sup><span class="unit">#{tool.sample_size_unit_name}</span></span> -
      <span class="exponent">10<sup class="text-max">#{tool.sample_size_max}</sup><span class="unit">#{tool.sample_size_unit_name}</span></span>
    HTML
  end

  def price_per_sample(tool, type=:base)
    price, lead_time = tool.send("#{type}_price"), tool.send("#{type}_lead_time")

    if price.present? && lead_time.present?
      number_to_currency(price, unit: currency_for(tool)) + " / " + content_tag(:span, pluralize(lead_time, "day"), class: "muted")
    end
  end

  def format_tool_price(tp, t)
    base = "%s: #{t.currency_symbol}%0.02f/%d days" % [ tp.label, tp.base_price, tp.lead_time_days ]
    if tp.can_expedite?
      base << ", #{t.currency_symbol}$%0.02f/%d days" % [ tp.expedite_price, tp.expedite_time_days ]
    end
    base
  end
end
