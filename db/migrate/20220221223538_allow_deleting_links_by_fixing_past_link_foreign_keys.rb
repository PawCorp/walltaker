class AllowDeletingLinksByFixingPastLinkForeignKeys < ActiveRecord::Migration[7.0]
  def change
    remove_column :past_links, :link_id, :integer
    change_column :past_links, :user_id, :integer, references: 'user', null: true, foreign_key: { on_delete: :cascade }
  end
end

