class CreateMispelledWords < ActiveRecord::Migration[5.1]
  def change
    create_table :mispelled_words do |t|
      t.string :content
      t.integer :word_id

      t.timestamps
    end
  end
end
