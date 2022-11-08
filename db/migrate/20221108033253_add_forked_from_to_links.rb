class AddForkedFromToLinks < ActiveRecord::Migration[7.0]
  def change
    add_reference :links, :forked_from, foreign_key: { to_table: :links }
  end
end
