ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)

require 'rspec/rails'
# require 'rspec/autorun'
require 'database_cleaner'
require 'rake'
require 'rails/tasks'
include ActiveSupport

Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

OmniAuth.config.test_mode = true

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
  config.include Warden::Test::Helpers
  config.infer_base_class_for_anonymous_controllers = true
  config.order = "random"

  Warden.test_mode!

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    # DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

  # enable one liner syntax for expect syntax
  config.alias_example_to :expect_it
end

# enable one liner syntax for expect syntax
RSpec::Core::MemoizedHelpers.module_eval do
  alias to should
  alias not_to should_not
end