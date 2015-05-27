class CreateRegressions < ActiveRecord::Migration
  def change
    create_table :regressions do |t|
      t.float :coeffs
      t.string :reg_type
      t.float :probability

      t.timestamps null: false
    end
  end
end
