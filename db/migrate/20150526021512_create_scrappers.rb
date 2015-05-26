class CreateScrappers < ActiveRecord::Migration
  def change
    create_table :scrappers do |t|

      t.timestamps null: false
    end
  end
end
