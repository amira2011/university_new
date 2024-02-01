class CreateLeads < ActiveRecord::Migration[7.1]
  def change
    create_table :leads do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :phone
      t.string :address
      t.string :address2
      t.string :city
      t.string :state
      t.string :zip
      t.index :city
      t.index :state
      t.index :zip

      t.timestamps
    end
  end
end
