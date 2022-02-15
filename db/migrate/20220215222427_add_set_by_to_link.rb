class AddSetByToLink < ActiveRecord::Migration[7.0]
  def change
    change_table :links do |t|
      t.references :set_by, index: false, foreign_key: { to_table: :users } # Don't make an index, this will update a lot
    end
  end
end
