class AddBackLinkForeignKeyToPastLinks < ActiveRecord::Migration[7.0]
  def change
    add_reference :past_links, :link, foreign_key: { on_delete: :nullify }
  end
end
