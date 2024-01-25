class AddColumnsToStudents < ActiveRecord::Migration[7.1]
  def change
    add_column :students, :age, :integer
    add_column :students, :category, :string
    add_column :students, :enrolled, :boolean
  end
end
