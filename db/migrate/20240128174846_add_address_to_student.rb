class AddAddressToStudent < ActiveRecord::Migration[7.1]
  def change
    add_column :students, :address, :string

  end
end
