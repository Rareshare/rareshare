class Tool < ActiveRecord::Base
  has_many :leases
  has_one :search, as: :searchable
  has_one :address, as: :addressable

  belongs_to :owner, class_name: "User"
  belongs_to :model
  belongs_to :manufacturer
  belongs_to :tool_category

  after_initialize :build_address
  after_save :update_search_document
  before_destroy :remove_search_document

  validates :model_id, :manufacturer_id, :price_per_hour, :owner, presence: true

  attr_accessible :manufacturer, :manufacturer_id
  attr_accessible :model, :model_id
  attr_accessible :description, :price_per_hour, :sample_size, :resolution, :technician_required, :sample_size_min, :sample_size_max
  accepts_nested_attributes_for :address, allow_destroy: true
  attr_accessible :address

  DEFAULT_SAMPLE_SIZE = [ -4, 4 ]
  after_initialize :set_default_sample_size

  class << self
    def name_delegator(*models)
      models.each do |model|
        define_method "#{model}_name" do
          self.send(model).try(:name)
        end

        define_method "#{model}_name=" do |name|
          model_class = model.to_s.classify.constantize
          self.send "#{model}=", model_class.where(name: name).first || model_class.create(name: name)
        end

        attr_accessible :"#{model}_name"
      end
    end
  end

  name_delegator :manufacturer, :model, :tool_category

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
    terms = [ self.resolution, self.model_name, self.manufacturer_name, self.tool_category_name ].compact.join(" ")
    
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
