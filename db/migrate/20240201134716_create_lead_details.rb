class CreateLeadDetails < ActiveRecord::Migration[7.1]
  def change
    create_table :lead_details do |t|
      t.references :lead, null: false, foreign_key: true
      t.boolean :home_garage
      t.boolean :home_owner
      t.integer :home_length
      t.boolean :interested_in_home_insurance
      t.boolean :interested_in_condo_insurance
      t.boolean :interested_in_life_insurance
      t.boolean :interested_in_renters_insurance
      t.boolean :interested_in_usage_based_policy
      t.boolean :currently_insured
      t.string :current_company
      t.integer :current_customer
      t.integer :continuous_coverage
      t.date :current_policy_expiration_date
      t.boolean :military_affiliation
      t.index :current_company
      t.timestamps
    end
  end
end
