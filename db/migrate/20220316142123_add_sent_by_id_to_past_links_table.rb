class AddSentByIdToPastLinksTable < ActiveRecord::Migration[7.0]
  def change
    change_table :past_links do |t|
      t.references :set_by, index: true, foreign_key: { to_table: :users }
    end
  end
end
