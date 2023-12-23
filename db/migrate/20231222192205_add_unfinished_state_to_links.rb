class AddUnfinishedStateToLinks < ActiveRecord::Migration[7.0]
  def change
    add_column :links, :wizard_page, :string, default: nil
  end
end
