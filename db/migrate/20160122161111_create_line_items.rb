class CreateLineItems < ActiveRecord::Migration[5.0]
  def change
    create_table :line_items do |t|
      t.references :order, null: false, index: true, foreign_key: true
      t.references :product, null: false, index: true, foreign_key: true
      t.integer :quantity, null: false

      t.timestamps
    end

    execute <<-sql
      ALTER TABLE line_items
        ADD CONSTRAINT line_items_valid_quantity
        CHECK (quantity > 0)
    sql
  end
end
