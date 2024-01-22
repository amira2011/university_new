class AddEmailToCustomers < ActiveRecord::Migration[7.1]
  def change
    add_column :customers, :email, :string
    add_index :customers, :email
  end
end
