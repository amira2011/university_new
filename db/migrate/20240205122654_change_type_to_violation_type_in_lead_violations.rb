class ChangeTypeToViolationTypeInLeadViolations < ActiveRecord::Migration[7.1]
  def change
    rename_column :lead_violations, :type, :violation_type
  end
end
