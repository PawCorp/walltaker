class AddDetailsColumnToUsersTable < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :details, :string
  end
end
