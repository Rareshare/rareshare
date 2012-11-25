class Manufacturer < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true
  has_many :models
  attr_accessible :name
end
