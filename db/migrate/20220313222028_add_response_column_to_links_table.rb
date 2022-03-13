class AddResponseColumnToLinksTable < ActiveRecord::Migration[7.0]
  def change
    add_column :links, :response_text, :string
    add_column :links, :response_type, :integer
  end
end
