class AddTitleToDocuments < ActiveRecord::Migration[5.1]
  def change
    remove_column :documents, :input, :string
    add_column :documents, :title, :string
  end
end
