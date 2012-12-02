# Be sure to restart your server when you modify this file.

Rareshare::Application.config.session_store :redis_store, key: '_rareshare_session', servers: ENV['REDISTOGO_URL']

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rails generate session_migration")
# Rareshare::Application.config.session_store :active_record_store
