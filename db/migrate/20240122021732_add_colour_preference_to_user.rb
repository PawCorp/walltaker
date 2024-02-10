class AddColourPreferenceToUser < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :colour_preference, :integer, default: 0
  end
end
