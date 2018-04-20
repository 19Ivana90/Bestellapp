class AddCustomerNameToOrders < ActiveRecord::Migration[5.0]
  def up
    change_column_null :orders, :customer_id, true
    add_column :orders, :customer_name, :text
    change_column_null :orders, :customer_name, false, 'leer'
  end

  def down
    remove_column :orders, :customer_name
    change_column_null :orders, :customer_id, false, 'leer'
  end
end
