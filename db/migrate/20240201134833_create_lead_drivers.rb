class CreateLeadDrivers < ActiveRecord::Migration[7.1]
  def change
    create_table :lead_drivers do |t|
      t.references :lead, null: false, foreign_key: true
      t.string :first_name
      t.string :last_name
      t.string :relationship
      t.string :gender
      t.string :marital_status
      t.date :birth_date
      t.integer :first_licensed
      t.string :education
      t.string :credit_rating
      t.boolean :bankruptcy
      t.string :occupation
      t.boolean :good_student
      t.string :license_status
      t.string :suspended_reason
      t.string :license_state
      t.boolean :sr_22
      t.index :relationship
      t.index :credit_rating
      t.timestamps
    end
  end
end
