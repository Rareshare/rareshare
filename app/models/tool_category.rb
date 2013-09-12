class ToolCategory < ActiveRecord::Base
  has_many :tools
  validates :name, presence: true, uniqueness: true
  default_scope { order(:name) }
end
