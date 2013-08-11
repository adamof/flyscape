class CreateCity < ActiveRecord::Migration
  def change
    create_table :cities do |t|
      t.string :name
      t.string :country_iso
      t.float :lat
      t.float :lng
    end
    add_index :cities, [:lat, :lng]
  end
end
