class CreateModels < ActiveRecord::Migration[8.0]
  def change
    create_table :models do |t|
      t.string :name, null: false
      t.integer :average_price, null: false
      t.references :brand, null: false, foreign_key: true

      t.timestamps
    end

    add_index :models, [:brand_id, :name], unique: true
    add_check_constraint :models, 'average_price > 100000', name: 'average_price_check'
  end
end