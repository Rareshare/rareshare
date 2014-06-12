CarrierWave.configure do |config|
  if ENV['AWS_ACCESS_KEY'] && ENV['AWS_SECRET_KEY']
    config.fog_credentials = {
      :provider               => 'AWS',
      :aws_access_key_id      => ENV['AWS_ACCESS_KEY'],
      :aws_secret_access_key  => ENV['AWS_SECRET_KEY']
    }
  end
  config.fog_directory  = ENV['AWS_BUCKET_NAME']
  config.fog_public     = true
end
