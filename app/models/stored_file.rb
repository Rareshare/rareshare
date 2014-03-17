class StoredFile < ActiveRecord::Base
  has_many :file_attachments
  belongs_to :user
  self.table_name = "files"
end
