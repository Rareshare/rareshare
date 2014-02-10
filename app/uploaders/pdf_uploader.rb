class PdfUploader < CarrierWave::Uploader::Base
  # Choose what kind of storage to use for this uploader:
  if Rails.env.development? || Rails.env.test?
    storage :file
  else
    storage :fog
  end

  # Add a white list of extensions which are allowed to be uploaded.
  def extension_white_list
    %w(pdf doc)
  end
end
