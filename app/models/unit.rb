class Unit < ActiveRecord::Base
  validates :name, :label, presence: true
end
