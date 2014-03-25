# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

#Role.create([{ name: 'admin' }, { name: 'lessor' }, { name: 'lessee' }])
Manufacturer.create([{ name: "Wayne Enterprises" }])
wayne = Manufacturer.first

Model.create([
  { name: "Particle Plus EH1P", manufacturer_id: wayne.id },
  { name: "Mega Microscope MM3H", manufacturer_id: wayne.id},
  { name: "Seek Sequencer MSSDN4", manufacturer_id: wayne.id}
])

