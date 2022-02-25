class AddNeverExpiresColumnToLinks < ActiveRecord::Migration[7.0]
  def change
    add_column :links, :never_expires, :boolean, default: false
  end
end
