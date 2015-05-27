class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.float :lat
      t.float :long
      t.string :location_id
      t.date :last_update
      t.integer :postcode_id

      t.timestamps null: false
    end
  end
end
