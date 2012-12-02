source 'https://rubygems.org'

# Basic infrastructure
gem 'rails', '3.2.8'
gem 'pg' # Basic Postgres driver.
gem 'therubyracer' # Javascript integration from within Ruby
gem 'uglifier' # JS asset compression
gem 'unicorn' # High-performance Ruby web server
gem 'seed-fu' # Seed test data
gem 'redis-rails' # Store sessions in Redis

# User management
gem 'devise' # A set of tools for user authentication
gem 'cancan' # A small set of tools for defining user permissions
gem 'texticle', require: 'texticle/rails' # Postgres full-text searching
gem 'omniauth' # Integrate Devise with OAuth providers
gem 'omniauth-linkedin'

# Code organization
gem 'active_attr' # Treat basic Ruby objects like models
gem 'aasm' # Add a state pattern to models

# Rendering and style
gem 'simple_form', git: "https://github.com/plataformatec/simple_form.git" # Riding master for bootstrap integration.
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
