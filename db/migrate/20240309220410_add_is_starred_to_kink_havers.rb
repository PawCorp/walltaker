class AddIsStarredToKinkHavers < ActiveRecord::Migration[7.1]
  def change
    add_column :kink_havers, :is_starred, :boolean, default: false, null: false
  end
end
