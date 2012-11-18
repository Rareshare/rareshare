class Model < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true
  belongs_to :manufacturer
  has_many :units
end
