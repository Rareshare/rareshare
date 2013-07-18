class FileAttachment < ActiveRecord::Base
  belongs_to :file, class_name: "StoredFile"
  belongs_to :attachable, polymorphic: true
  validates_uniqueness_of :file_id, scope: [:attachable_id, :attachable_type, :category]

  default_scope { order(:position) }

  def as_json(options={})
    super(options.merge(methods: [:url, :thumbnail]))
  end

  def url; file.url; end
  def thumbnail; file.thumbnail; end

  module Categories
    IMAGE    = "image"
    DOCUMENT = "document"
  end
end
