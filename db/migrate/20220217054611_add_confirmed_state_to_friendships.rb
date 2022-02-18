class AddConfirmedStateToFriendships < ActiveRecord::Migration[7.0]
  def change
    add_column :friendships, :confirmed, :boolean
    add_index :friendships, %i[sender_id receiver_id], unique: true
  end
end
