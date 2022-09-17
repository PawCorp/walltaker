class AddPasswordResetTokenToUsersTable < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :password_reset_token, :string, null: true
  end
end
