class AvailableUnit < ActiveRecord::Base

  validates :name, presence: true, uniqueness: true, inclusion: { in: Unit.definitions.keys, message: "%{value} is not a valid unit" }

  def definition
    Unit.definitions[self.name]
  end

  def display_name
    definition.display_name
  end

end
