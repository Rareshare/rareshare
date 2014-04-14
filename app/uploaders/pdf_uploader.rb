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
    unless model.class.to_s == "TermsDocument"
      if model.name
        if PdfFile.find_by(name: model.name)
          new_name = "#{model.created_at.to_s}_#{model.name}"
          model.name = new_name
          new_name
        else
          model.name
        end
      end
    end
  end

  # Add a white list of extensions which are allowed to be uploaded.
  def extension_white_list
    EXTENSIONS
  end
end
