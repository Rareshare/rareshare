class AvailableUnit < ActiveRecord::Base

  validates :name, presence: true, uniqueness: true, inclusion: { in: Unit.definitions.keys, message: "%{value} is not a valid unit" }

  def definition
    Unit.definitions[self.name]
  end

  def display_name
    definition.display_name
  end

  class << self
    def for(name)
      where(name: name).first || create!(name: name)
    end
  end

  def as_json
    definition.as_json.except("scalar").merge(id: self.name, plural: definition.name.pluralize)
  end

end
