class CreatePostcodes < ActiveRecord::Migration
  def change
    create_table :postcodes do |t|
      t.integer :code_id

      t.timestamps null: false
    end
  end
end
