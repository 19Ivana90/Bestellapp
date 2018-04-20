class CreateProductAvailabilities < ActiveRecord::Migration[5.0]
  def change
    create_table :product_availabilities do |t|
      t.references :product, null: false, index: true
      t.string :country_code, null: false, limit: 2
      t.text :sku, null: false

      t.timestamps
    end

    add_index :product_availabilities, [:product_id, :country_code], unique: true
    add_index :product_availabilities, :sku, unique: true
    add_foreign_key :product_availabilities, :products, on_delete: :cascade
  end
end
