class Manufacturer < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true
  has_many :models
end
