class AddAcceptedAtToOrders < ActiveRecord::Migration[5.0]
  def up
    add_column :orders, :accepted_at, :datetime
    execute <<-sql
      ALTER TABLE orders
        ADD CONSTRAINT orders_require_customer_id_when_accepted
        CHECK (accepted_at IS NULL OR (customer_id IS NOT NULL AND TRIM(customer_id) != ''))
    sql
  end

  def down
    remove_column :orders, :accepted_at
  end
end
