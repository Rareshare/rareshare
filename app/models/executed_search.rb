class ExecutedSearch < ActiveRecord::Base
  belongs_to :user
  store_accessor :search_params
end
