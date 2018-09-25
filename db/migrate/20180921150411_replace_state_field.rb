class ReplaceStateField < ActiveRecord::Migration[5.2]
  def change
      change_column :orders, :state, :string, :limit =>25
  end
end
