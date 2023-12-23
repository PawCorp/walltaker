class AddUnfinishedStateToLinks < ActiveRecord::Migration[7.0]
  def change
    add_column :links, :unfinished, :boolean, default: false
  end
end
