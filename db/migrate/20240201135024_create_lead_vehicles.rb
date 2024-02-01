class CreateLeadVehicles < ActiveRecord::Migration[7.1]
  def change
    create_table :lead_vehicles do |t|
      t.references :lead, null: false, foreign_key: true
      t.references :lead_driver, null: false, foreign_key: true
      t.string :year
      t.string :make
      t.string :model
      t.string :submodel
      t.string :vin
      t.boolean :alarm
      t.string :primary_purpose
      t.string :average_mileage
      t.integer :commute_days_per_week
      t.string :annual_mileage
      t.string :ownership
      t.string :collision
      t.string :comprehensive

      t.timestamps
    end
  end
end
