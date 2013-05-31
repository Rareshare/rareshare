class Address < ActiveRecord::Base
  validates :address_line_1, :city, :postal_code, :country, presence: true
  belongs_to :addressable, polymorphic: true

  def full_street_address
    [ self.address_line_1, self.address_line_2, city, "#{state} #{postal_code}"  ].reject(&:blank?).join(", ")
  end
end
