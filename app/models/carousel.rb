class Carousel < ActiveRecord::Base
  belongs_to :tool, foreign_key: :resource_id
  mount_uploader :image, ImageUploader

  validates_presence_of :resource_type, :resource_id, :image

  scope :active, -> { where(active: true) }

  def resource
    if resource_type == 'Tool'
      tool
    end
  end
end