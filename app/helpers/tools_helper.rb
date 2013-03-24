module ToolsHelper
  def max_possible_sample_size
    SampleSize.all_sizes.last.exponent
  end

  def min_possible_sample_size
    SampleSize.all_sizes.first.exponent
  end

  def sample_size_text(tool)
    <<-HTML.html_safe
      <span class="exponent">10<sup class="text-min">#{tool.sample_size_min}</sup>m - <span class="exponent">10<sup class="text-max">#{tool.sample_size_max}</sup>m</span>
    HTML
  end

  def price_per_sample(tool, type=:base)
    price, lead_time = tool.send("#{type}_price"), tool.send("#{type}_lead_time")

    if price.present? && lead_time.present?
      number_to_currency(price) + " / " + content_tag(:span, pluralize(lead_time, "day"), class: "muted")
    end
  end
end
