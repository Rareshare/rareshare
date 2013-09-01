class RequestedSearch < ActiveRecord::Base
  belongs_to :user
  validates :request, presence: true
end
