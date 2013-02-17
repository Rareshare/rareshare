class Tool < ActiveRecord::Base
  has_many :leases
  has_one :search, as: :searchable
  has_one :address, as: :addressable

  belongs_to :owner, class_name: "User"
  belongs_to :model
  belongs_to :manufacturer
  belongs_to :tool_category
  belongs_to :user, counter_cache: true, foreign_key: :owner_id

  has_many :user_messages, as: :topic
  has_many :images, as: :imageable

  after_initialize :build_address_if_blank
  after_save :update_search_document
  before_destroy :remove_search_document

  validates :model_name, :manufacturer_name, :tool_category_name, :price_per_hour, :owner, presence: true

  attr_accessible :manufacturer, :manufacturer_id, :year_manufactured, :serial_number
  attr_accessible :model, :model_id
  attr_accessible :description, :price_per_hour, :sample_size, :resolution, :technician_required, :sample_size_min, :sample_size_max
  accepts_nested_attributes_for :address, allow_destroy: true
  attr_accessible :address_attributes

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

  def possible_years
    Date.today.year.downto(1970).to_a
  end

  def build_address_if_blank
    build_address if self.address.blank?
  end

  def leaseable_by?(user)
    user.id != self.owner_id
  end

  private

  def update_search_document
    terms = [ self.tool_category_name, self.manufacturer_name, self.model_name, self.description, self.serial_number ].compact.join(" ")

    if search.present?
      Search.where(searchable_id: self.id, searchable_type: self.class.name).update_all(document: terms)
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
