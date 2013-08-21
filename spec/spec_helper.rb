require 'rubygems'
require 'spork'

#uncomment the following line to use spork with the debugger
#require 'spork/ext/ruby-debug'

Spork.prefork do
  ENV["RAILS_ENV"] ||= 'test'
  require File.expand_path("../../config/environment", __FILE__)

  require 'rspec/rails'
  require 'rspec/autorun'

  require 'capybara/rails'
  require 'capybara/rspec'
  # require 'capybara-screenshot/rspec'
  require 'database_cleaner'
  require 'no_peeping_toms'
  # require 'capybara/poltergeist'

  # Capybara.javascript_driver = :poltergeist
  OmniAuth.config.test_mode = true

  RSpec.configure do |config|
    config.include FactoryGirl::Syntax::Methods
    config.include Warden::Test::Helpers
    config.infer_base_class_for_anonymous_controllers = true
    config.order = "random"
    ActiveRecord::Observer.disable_observers
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
  end
end

Spork.each_run do
  # This code will be run each time you run your specs.
  Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}
  FactoryGirl.find_definitions
end
