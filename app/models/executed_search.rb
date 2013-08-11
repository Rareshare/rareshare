class ExecutedSearch < ActiveRecord::Base
  belongs_to :user
  serialize :search_params, ActiveRecord::Coders::Hstore
end
