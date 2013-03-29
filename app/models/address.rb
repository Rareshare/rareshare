class Address < ActiveRecord::Base
  validates :address_line_1, :city, :state, :zip_code, presence: true

  attr_accessible :address_line_1, :address_line_2, :city, :state, :zip_code, presence: true

  belongs_to :addressable, polymorphic: true

  def full_street_address
    [ self.address_line_1, self.address_line_2 ].compact.join(", ") + ", #{city}, #{state} #{zip_code}"
  end
end
