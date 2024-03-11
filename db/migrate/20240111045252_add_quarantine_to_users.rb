class AddQuarantineToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :quarantined, :boolean, default: false
  end
end
