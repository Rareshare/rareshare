class ImageFile < StoredFile
  mount_uploader :file, ImageUploader

  def url
    self.file.url
  end

  def thumbnail
    self.file.thumb.url
  end

  def as_json(options={})
    super(options.merge(methods: [:thumbnail, :url]))
  end

end
