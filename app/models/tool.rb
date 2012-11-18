class Tool < ActiveRecord::Base
  has_many :leases
  belongs_to :owner, class_name: "User"
end
