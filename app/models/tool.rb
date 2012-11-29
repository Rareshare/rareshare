class Tool < ActiveRecord::Base
  has_many :leases
  has_one :search, as: :searchable
  belongs_to :owner, class_name: "User"
  belongs_to :model
  belongs_to :manufacturer

  after_save :update_search_document
  before_destroy :remove_search_document

  def manufacturer_name
    manufacturer.try(:name)
  end

  def model_name
    model.try(:name)
  end

  def model_name=(name)
    self.model = Model.where(name: name).first || Model.create(name: name)
  end

  def manufacturer_name=(name)
    self.manufacturer = Manufacturer.where(name: name).first || Manufacturer.create(name: name)
  end

  def self.search(query)
    Search.search(searchable_type: self.name, document: query).map(&:searchable)
  end

  def display_name
    "#{manufacturer_name} #{model_name}"
  end

  def price_per_hour_adjusted
    self.price_per_hour / 100.0
  end

  private

  def update_search_document
    terms = [ self.sample_size, self.resolution, self.model_name, self.manufacturer_name ].compact.join(" ")
    
    if search.present?
      search.update_attributes(document: terms)
    else
      Search.create(searchable_id: self.id, searchable_type: self.class.name, document: terms)
    end
  end

  def remove_search_document
    Search.delete_all(searchable_id: self.id, searchable_type: self.class.name)
  end
end
