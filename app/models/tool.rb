class Tool < ActiveRecord::Base
  has_many :leases
  has_one :search, as: :searchable
  belongs_to :owner, class_name: "User"
  belongs_to :model
  belongs_to :manufacturer

  after_save :update_search_document
  before_destroy :remove_search_document

  validates :model_id, :manufacturer_id, :price_per_hour, :owner, presence: true
  attr_accessible :manufacturer, :manufacturer_id, :manufacturer_name
  attr_accessible :model, :model_id, :model_name
  attr_accessible :description, :price_per_hour, :sample_size, :resolution, :technician_required, :sample_size_min, :sample_size_max

  DEFAULT_SAMPLE_SIZE = [ -4, 4 ]
  after_initialize :set_default_sample_size

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

  def price_per_hour=(price)
    return if price.blank?

    if price.is_a?(String)
      price = Float(price) * 100
    end

    super(price)
  end

  private

  def update_search_document
    terms = [ self.resolution, self.model_name, self.manufacturer_name ].compact.join(" ")
    
    if search.present?
      search.update_attributes(document: terms)
    else
      Search.create(searchable_id: self.id, searchable_type: self.class.name, document: terms)
    end
  end

  def remove_search_document
    Search.delete_all(searchable_id: self.id, searchable_type: self.class.name)
  end

  def set_default_sample_size
    min, max = DEFAULT_SAMPLE_SIZE
    self.sample_size_min ||= min
    self.sample_size_max ||= max
  end
end
