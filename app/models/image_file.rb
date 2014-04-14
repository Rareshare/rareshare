class ImageFile < StoredFile
  mount_uploader :file, ImageFileUploader

  def url
    self.file.url
  end

  def thumbnail
    self.file.thumb.url
  end

  def as_json(opts)
    super(opts.merge(methods: [:thumbnail]))
  end

end
