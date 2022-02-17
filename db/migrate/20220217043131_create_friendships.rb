class CreateFriendships < ActiveRecord::Migration[7.0]
  def change
    create_table :friendships do |t|
      t.references :sender, index: true, null: false, foreign_key: { to_table: :users }
      t.references :receiver, index: true, null: true, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
