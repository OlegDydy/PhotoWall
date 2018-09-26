class RenameCustomerToUser < ActiveRecord::Migration[5.2]
  def change
    remove_column :orders, :customer
    add_reference :orders, :user, index: true
  end
end
