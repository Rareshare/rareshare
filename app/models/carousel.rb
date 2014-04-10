class Carousel < ActiveRecord::Base
  belongs_to :tool, foreign_key: :resource_id
  mount_uploader :image, ImageUploader

  validates_presence_of :image
  validates_format_of :external_link_url, with: URI::regexp(%w(http https)), allow_blank: true
  validate :linkable

  scope :active, -> { where(active: true) }

  def resource
    if resource_type == 'Tool'
      tool
    end
  end

  def resource_present?
    resource_type.present? && resource_id.present?
  end

  def external_link_present?
    external_link_url.present? && external_link_text.present?
  end

  private

  def linkable
    unless resource_present? || external_link_present? || custom_content.present?
      errors.add(:base, "must have linkable content.")
    end
  end
end