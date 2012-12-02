module ToolsHelper
  def max_possible_sample_size
    SampleSize.all_sizes.last.exponent
  end

  def min_possible_sample_size
    SampleSize.all_sizes.first.exponent
  end

  def sample_size_text(tool)
    <<-HTML.html_safe
      <span class="exponent">10<sup class="text-min">#{tool.sample_size_min}</sup> - <span class="exponent">10<sup class="text-max">#{tool.sample_size_max}</sup></span>
    HTML
  end
end