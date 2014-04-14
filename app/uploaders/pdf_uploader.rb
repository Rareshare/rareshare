class PdfUploader < CarrierWave::Uploader::Base
  # Choose what kind of storage to use for this uploader:
  if Rails.env.development? || Rails.env.test?
    storage :file
  else
    storage :fog
  end

  EXTENSIONS = %w(pdf)

  def store_dir
    "docs/#{model.class.to_s.underscore}"
  end

  def filename
    if model.name
      if PdfFile.find_by(name: model.name)
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
