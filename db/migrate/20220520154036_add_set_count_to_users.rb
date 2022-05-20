class AddSetCountToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :set_count, :integer, null: false, default: 0
    add_index :users, :set_count, order: { set_count: :desc }
  end
end
