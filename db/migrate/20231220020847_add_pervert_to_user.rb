class AddPervertToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :pervert, :boolean
  end
end
