Braintree::Configuration.tap do |c|
  c.environment = ( ENV['BRAINTREE_ENV'] || "sandbox" ).to_sym
  c.merchant_id = ENV['BRAINTREE_MERCHANT_ID']
  c.public_key  = ENV['BRAINTREE_PUBLIC_KEY']
  c.private_key = ENV['BRAINTREE_PRIVATE_KEY']
end
