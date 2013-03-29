class AddGeolocationToTools < ActiveRecord::Migration
  def up
    add_column :tools, :latitude, :float
    add_column :tools, :longitude, :float

    execute <<-SQL
      UPDATE tools
      SET
        longitude = addresses.longitude,
        latitude = addresses.latitude
      FROM addresses
      WHERE
        addresses.addressable_id = tools.id AND
        addresses.addressable_type = 'Tool'
    SQL

    remove_column :addresses, :latitude
    remove_column :addresses, :longitude
  end

  def down
    add_column :addresses, :latitude, :float
    add_column :addresses, :longitude, :float

    execute <<-SQL
      UPDATE addresses
      SET
        longitude = tools.longitude,
        latitude = tools.latitude
      FROM tools
      WHERE
        addressable_id = tools.id AND
        addressable_type = 'Tool'
    SQL

    remove_column :tools, :latitude
    remove_column :tools, :longitude
  end
end
