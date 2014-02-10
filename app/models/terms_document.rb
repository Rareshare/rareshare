class TermsDocument < ActiveRecord::Base
  validates :title, presence: true
  belongs_to :user
  has_many :tools

  mount_uploader :pdf, PdfUploader
end
