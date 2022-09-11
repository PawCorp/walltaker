class AddViewingLinkColumnToUsers < ActiveRecord::Migration[7.0]
  def change
    add_reference :users, :viewing_link, null: true, foreign_key: { to_table: :links }
  end
end
