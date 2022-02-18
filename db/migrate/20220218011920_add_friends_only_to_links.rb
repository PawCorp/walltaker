class AddFriendsOnlyToLinks < ActiveRecord::Migration[7.0]
  def change
    add_column :links, :friends_only, :boolean
  end
end
