class Facility < ActiveRecord::Base
  has_many :tools
  belongs_to :user
  has_one :address, as: :addressable

  accepts_nested_attributes_for :address, allow_destroy: false

  validates :name, presence: true

  def title
    unless new_record?
      if self.name.blank?
        self.address.full_street_address
      else
        self.name + " (#{self.address.full_street_address})"
      end
    end
  end

  def as_json(options={})
    super(options).merge(address: address || Address.new)
  end
end
