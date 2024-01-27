class RenameCourseColumn < ActiveRecord::Migration[7.1]
  def change
    rename_column :courses, :name, :course_name

  end
end
