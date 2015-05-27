class CreateData < ActiveRecord::Migration
  def change
    create_table :data do |t|
      t.float :rainfall
      t.string :wind_direction
      t.float :wind_speed
      t.float :temperature
      t.integer :postcode_id
      t.integer :location_id
      t.string :current_condition

      t.timestamps null: false
    end
  end
end
