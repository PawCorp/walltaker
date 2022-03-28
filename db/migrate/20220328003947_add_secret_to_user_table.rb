class AddSecretToUserTable < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :secret, :string
  end
end
