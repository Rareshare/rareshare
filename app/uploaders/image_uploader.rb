class ImageUploader < CarrierWave::Uploader::Base
  # include CarrierWave::RMagick
  include CarrierWave::MiniMagick

  # Include the Sprockets helpers for Rails 3.1+ asset pipeline compatibility:
  # Seems to be broken in Rails 4
  # include Sprockets::Helpers::RailsHelper
  # include Sprockets::Helpers::IsolatedHelper

  # Choose what kind of storage to use for this uploader:
  if Rails.env.development? || Rails.env.test?
    storage :file
  else
    storage :fog
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # We won't need bigger, and this seems to be what Instagram/FB display.
  process :resize_to_fit => [612,612]

  version :thumb do
    process :resize_to_fill => [100,100]
  end

  EXTENSIONS = %w(jpg jpeg gif png)

  def store_dir
    "photos/#{model.class.to_s.underscore}"
  end

  def filename
    if model.name
      if ImageFile.find_by(name: model.name)
        "#{model.created_at.to_s}_#{model.name}"
      else
        model.name
      end
    end
  end

  # Add a white list of extensions which are allowed to be uploaded.
  def extension_white_list
    EXTENSIONS
  end
end
