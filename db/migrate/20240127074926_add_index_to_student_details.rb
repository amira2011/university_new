class AddIndexToStudentDetails < ActiveRecord::Migration[7.1]
  def change
    add_index :students, :email
    add_index :students, :category
    add_index :student_details, :zip

  end
end



