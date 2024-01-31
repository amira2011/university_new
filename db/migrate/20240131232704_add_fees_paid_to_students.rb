class AddFeesPaidToStudents < ActiveRecord::Migration[7.1]
  def change
    add_column :students, :fees_paid, :decimal, precision: 10, scale: 2
  end
end
