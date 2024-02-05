class CreateLeadViolations < ActiveRecord::Migration[7.1]
  def change
    create_table :lead_violations do |t|
      t.string :violation_type
      t.references :lead_driver, null: false, foreign_key: true
      t.references :lead, null: false, foreign_key: true
      t.date :incident_date
      t.string :description
      t.string :what_damaged
      t.boolean :accident_at_fault
      t.boolean :claim_at_fault
      t.string :amount_paid
      t.string :dui_state
      t.index :dui_state
      t.timestamps
    end
  end
end
