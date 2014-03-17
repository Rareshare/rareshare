class PdfFile < StoredFile
  mount_uploader :file, PdfUploader
end
