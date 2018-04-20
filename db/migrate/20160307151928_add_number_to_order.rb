class AddNumberToOrder < ActiveRecord::Migration[5.0]
  def up
    add_column :orders, :number, :text
    add_index :orders, :number, unique: true

    Order.accepted.each do |order|
      order.update_column(:number, Order.next_number)
    end

    execute <<-sql
      ALTER TABLE orders
        ADD CONSTRAINT orders_number_required_for_accepted_order
        CHECK (accepted_at IS NULL OR number IS NOT NULL)
    sql
  end

  def down
    remove_column :orders, :number
  end
end
