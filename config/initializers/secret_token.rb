# Be sure to restart your server when you modify this file.

# Your secret key for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!
# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
Rareshare::Application.config.secret_token = '7ed84812e1809ced4412c577a535f30bd6ef6a904d7e9ae523e1405faf082b44d28d52034cc67c986076be91db0c9211ce9adbf7ac14830626e2bcaa2244d65a'
Rareshare::Application.config.secret_key_base = ENV['SECRET_KEY_BASE'] || '10e4712bc8a68481966cfbb3340b404fc268ad1443e026fe2507156793093af8593fa56339d6dbfb44f98fbefa23186dbf5d1f1952239aef608a335af7be7974'
