class Tool < ActiveRecord::Base
  has_many :leases
  has_one :search, as: :searchable, dependent: :destroy
  belongs_to :owner, class_name: "User"
  belongs_to :model

  after_save :update_search_document

  def manufacturer_name
    model.try(:manufacturer).try(:name)
  end

  def model_name
    model.try(:name)
  end

  def self.search(query)
    Search.search(searchable_type: self.name, document: query)
  end

  private

  def update_search_document
    terms = [ self.sample_size, self.resolution, self.model_name, self.manufacturer_name ].compact.join(" ")
    
    if search.present?
      search.update(document: terms)
    else
      Search.create(searchable_id: self.id, searchable_type: self.class.name, document: terms)
    end
  end
end
