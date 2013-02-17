source 'https://rubygems.org'

# Basic infrastructure
gem 'rails', '3.2.12'
gem 'pg' # Basic Postgres driver.
gem 'therubyracer' # Javascript integration from within Ruby
gem 'uglifier' # JS asset compression
gem 'unicorn' # High-performance Ruby web server
gem 'seed-fu' # Seed test data
gem 'redis-rails' # Store sessions in Redis

# Image management
gem 'carrierwave'
gem 'fog'
gem 'mini_magick'

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

# Rendering and style
gem 'haml-rails'
gem 'coffee-rails'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'less-rails'
gem 'twitter-bootstrap-rails'

group :development do
  gem 'foreman'
end

group :test do
  gem 'factory_girl'
  gem 'rspec-rails'
end
