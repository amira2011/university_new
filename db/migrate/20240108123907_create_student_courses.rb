class CreateStudentCourses < ActiveRecord::Migration[7.1]
  def change
    create_table :student_courses do |t|

      t.belongs_to :student
      t.belongs_to :course
    
      t.timestamps
    end
  end
end
