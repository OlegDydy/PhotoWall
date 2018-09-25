class AddCustomerToOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :customer, :integer, default: 1
  end
end
