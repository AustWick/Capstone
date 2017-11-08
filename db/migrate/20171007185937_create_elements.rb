class CreateElements < ActiveRecord::Migration[5.1]
  def change
    create_table :elements do |t|
      t.integer :document_id
      t.string :content
      t.integer :order

      t.timestamps
    end
  end
end
