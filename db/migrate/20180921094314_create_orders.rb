class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.string :caption
      t.text :description
      t.float :price
      t.string :in_image_url
      t.string :out_image_url
      t.integer :state

      t.timestamps
    end
  end
end
