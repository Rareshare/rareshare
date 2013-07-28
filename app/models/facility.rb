class Facility < ActiveRecord::Base
  has_many :tools
  belongs_to :user
  has_one :address, as: :addressable

  accepts_nested_attributes_for :address

  def title
    if self.name.blank?
      self.address.full_street_address
    else
      self.name + " (#{self.address.full_street_address})"
    end
  end
end
