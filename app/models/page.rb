class Page < ActiveRecord::Base
  extend FriendlyId
  friendly_id :title, use: [:slugged, :finders]

  mount_uploader :pdf, PdfUploader

  def html_content
    Redcarpet::Markdown.new(Redcarpet::Render::HTML.new(with_toc_data: true)).render(self.content).html_safe
  end
end
