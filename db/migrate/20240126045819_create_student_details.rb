class CreateStudentDetails < ActiveRecord::Migration[7.1]
  def change
    create_table :student_details do |t|
      t.references :student, null: false, foreign_key: true
      t.string :address
      t.string :zip
      t.string :emergency_contact

      t.timestamps
    end
  end
end
