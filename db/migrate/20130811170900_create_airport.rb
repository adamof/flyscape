class CreateAirport < ActiveRecord::Migration
  def change
    create_table :airports do |t|
      t.string :name
      t.string :iata
      t.float :lat
      t.float :lng
      t.integer :city_id
    end
  end
end
