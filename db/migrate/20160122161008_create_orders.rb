class CreateOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :orders do |t|
      t.references :user, null: false, index: true, foreign_key: true

      t.text :customer_id, null: false
      t.string :country_code, null: false, limit: 2

      t.datetime :placed_at

      t.timestamps
    end
  end
end
