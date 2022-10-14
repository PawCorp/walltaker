class AddCustomUrlToLinks < ActiveRecord::Migration[7.0]
  def change
    add_column :links, :custom_url, :string, null: true
  end
end
