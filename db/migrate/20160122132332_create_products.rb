class CreateProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :products do |t|
      t.text :name, null: false
      t.integer :carton_size

      t.timestamps
    end
  end
end
