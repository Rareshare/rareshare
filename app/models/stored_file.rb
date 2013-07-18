class StoredFile < ActiveRecord::Base
  include Filepicker::Rails::ViewHelpers
  has_many :file_attachments
  belongs_to :user
  set_table_name "files"

  def image?
    content_type =~ /^image\//
  end

  def thumbnail
    filepicker_image_url(self.url, w: 100, h: 100) if image?
  end

  def as_json(options={})
    super(options.merge(methods: [:thumbnail]))
  end
end
