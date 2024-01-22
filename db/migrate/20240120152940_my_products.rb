class MyProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :my_products do |t|

      t.integer :product_id
      t.string :name
      
    t.timestamps
  end
  end
end
