require 'spec_helper'
require 'capybara/poltergeist'

Capybara.javascript_driver = :poltergeist

include Warden::Test::Helpers

Capybara.register_driver :poltergeist do |app|
  options = {
    # :debug => true,
    :inspector => true,
    :js_errors => true
  }
  Capybara::Poltergeist::Driver.new(app, options)
end