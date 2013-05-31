class InternationlizeAddresses < ActiveRecord::Migration
  class Address < ActiveRecord::Base
  end

  def change
    rename_column :addresses, :zip_code, :postal_code
    add_column :addresses, :country, :string

    Address.update_all(country: "us")
  end
end
