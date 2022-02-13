class AddTagsToLinks < ActiveRecord::Migration[7.0]
  def change
    add_column :links, :blacklist, :string
  end
end
