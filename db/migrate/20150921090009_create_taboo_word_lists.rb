class CreateTabooWordLists < ActiveRecord::Migration
  def change
    create_table :taboo_word_lists do |t|
      t.string :word
      t.string :taboo_word_1
      t.string :taboo_word_2
      t.string :taboo_word_3
      t.string :taboo_word_4
      t.string :taboo_word_5
      t.integer :version_number

      t.timestamps null: false
    end
  end
end
