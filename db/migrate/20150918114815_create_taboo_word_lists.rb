class CreateTabooWordLists < ActiveRecord::Migration
  def change
    create_table :taboo_word_lists do |t|
      t.string :taboo_word
      t.string :option1
      t.string :option2
      t.string :option3
      t.string :option4
      t.string :option5
      t.boolean :flag

      t.timestamps null: false
    end
  end
end
