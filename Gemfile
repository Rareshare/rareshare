source 'https://rubygems.org'
ruby '2.0.0'

# Basic infrastructure
gem 'rails', '4.0.5'
gem 'pg' # Basic Postgres driver.
gem 'therubyracer' # Javascript integration from within Ruby
gem 'uglifier' # JS asset compression
gem 'unicorn' # High-performance Ruby web server
gem 'seed-fu' # Seed test data
gem 'redis-rails' # Store sessions in Redis
gem 'rails-observers' # Add in support for ActiveRecord observers.

# Background jobs
gem 'sidekiq' # Main lib
gem 'slim', '>= 1.1.0'
gem 'sinatra', '>= 1.3.0', :require => nil

# Payment
gem 'braintree'

# Image management
gem 'carrierwave'
gem 'fog'
gem 'mini_magick'
gem 'jquery-fileupload-rails'
gem 'mime-types'

# Admin
gem 'activeadmin', github: 'gregbell/active_admin'
# gem 'active_admin_editor' # No Rails 4
# gem 'meta_search'

# User management
gem 'devise', '~> 3.1.0' # A set of tools for user authentication
gem 'devise-async'
gem 'cancan' # A small set of tools for defining user permissions
gem 'textacular', '~> 3.0' # Postgres full-text searching
gem 'omniauth' # Integrate Devise with OAuth providers
gem 'omniauth-linkedin' # Integrate Linkedin specifically.

# Support and extensions
gem 'active_attr' # Treat basic Ruby objects like models
gem 'transitions', :require => ["transitions", "active_model/transitions"]
gem 'geocoder' # Geocoding support
gem 'simple_form', '~> 3.0' # Easy form builder.
gem 'kaminari' # ARec pagination
gem 'friendly_id', github: 'norman/friendly_id' # Standard slugged ID management
# gem 'ruby-units' # Definitions for standard and scientific units.
gem 'country_select', git: "git://github.com/stefanpenner/country_select.git" # Use ISO codes.
gem 'draper' # Decorator pattern

# Shipping and payment
gem 'easypost'
gem 'stripe'
# gem 'active_shipping'

# Rendering and style
gem 'haml-rails'
gem 'coffee-rails'
gem 'sass-rails', '>= 4.0.3'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'momentjs-rails'
gem 'less-rails'
gem 'twitter-bootstrap-rails'
gem 'bootstrap-wysihtml5-rails'
gem 'redcarpet'

# Monitoring and reporting
gem 'honeybadger'
gem 'newrelic_rpm'

group :production do
  gem 'rails_12factor'
end

group :development do
  gem 'foreman'
  gem 'heroku_san'
  gem 'heroku'
  gem 'zeus'
  gem 'mailcatcher'
end

group :test do
  gem 'factory_girl_rails'
  gem 'rspec-rails', '~> 2.14.2'
  gem 'rspec-given' # Given-when-then for specs
  gem 'no_peeping_toms', require: false # Disable observers during tests.
  gem 'capybara'
  gem 'capybara-screenshot'
  gem 'poltergeist'
  # gem 'spork-rails', github: 'sporkrb/spork-rails' # Not happy with Rails 4
  gem 'selenium-webdriver'
  gem 'database_cleaner' # Reset database properly for browser specs.
  gem 'shoulda-matchers'
end
