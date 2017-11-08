class CreateDocuments < ActiveRecord::Migration[5.1]
  def change
    create_table :documents do |t|
      t.integer :user_id
      t.text :input
      t.timestamps
    end
  end
end
