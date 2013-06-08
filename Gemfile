source 'https://rubygems.org'

# Basic infrastructure
gem 'rails', '3.2.12'
gem 'pg' # Basic Postgres driver.
gem 'therubyracer' # Javascript integration from within Ruby
gem 'uglifier' # JS asset compression
gem 'unicorn' # High-performance Ruby web server
gem 'seed-fu' # Seed test data
gem 'redis-rails' # Store sessions in Redis

# Payment
gem 'braintree'

# Image management
gem 'carrierwave'
gem 'fog'
gem 'mini_magick'
gem "jquery-fileupload-rails"

# Admin
gem 'activeadmin'
gem 'active_admin_editor'
gem 'meta_search', '>= 1.1.0.pre'

# User management
gem 'devise' # A set of tools for user authentication
gem 'cancan' # A small set of tools for defining user permissions
gem 'texticle', require: 'texticle/rails' # Postgres full-text searching
gem 'omniauth' # Integrate Devise with OAuth providers
gem 'omniauth-linkedin' # Integrate Linkedin specifically.

# Support and extensions
gem 'active_attr' # Treat basic Ruby objects like models
gem 'transitions', :require => ["transitions", "active_model/transitions"]
gem 'geocoder' # Geocoding support
gem 'simple_form', '~> 2.0.4' # Easy form builder.
gem 'strong_parameters' # Better parameter support.
gem 'kaminari'
gem 'friendly_id' # Standard ID generation.
gem 'ruby-units' # Definitions for standard and scientific units.
gem 'country_select', git: "git://github.com/stefanpenner/country_select.git" # Use ISO codes.

# Rendering and style
gem 'haml-rails'
gem 'coffee-rails'
gem 'sass-rails'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'less-rails'
gem 'twitter-bootstrap-rails'
gem 'bootstrap-wysihtml5-rails'
gem 'redcarpet'

group :development do
  gem 'foreman'
end

group :test do
  gem 'factory_girl'
  gem 'rspec-rails'
  gem 'no_peeping_toms' # Disable observers during tests.
  gem 'capybara'
  gem 'poltergeist'
  gem 'spork-rails'
end
