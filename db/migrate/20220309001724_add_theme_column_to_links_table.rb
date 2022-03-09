class AddThemeColumnToLinksTable < ActiveRecord::Migration[7.0]
  def change
    add_column :links, :theme, :string
  end
end
