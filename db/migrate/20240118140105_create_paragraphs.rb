class CreateParagraphs < ActiveRecord::Migration[7.1]
  def change
    create_table :paragraphs do |t|
      t.string :name
      t.belongs_to :section
      t.timestamps
    end
  end
end
