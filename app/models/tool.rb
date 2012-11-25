class Tool < ActiveRecord::Base
  has_many :leases
  has_one :search, as: :searchable
  belongs_to :owner, class_name: "User"
  belongs_to :model

  after_save :update_search_document
  before_destroy :remove_search_document

  def manufacturer_name
    model.try(:manufacturer).try(:name)
  end

  def model_name
    model.try(:name)
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
    Search.where(searchable_id: self.id, searchable_type: self.class.name).destroy
  end
end
