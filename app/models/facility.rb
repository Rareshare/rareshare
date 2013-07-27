class Facility < ActiveRecord::Base
  has_many :tools
  belongs_to :user
  has_one :address, as: :addressable

  accepts_nested_attributes_for :address
end
