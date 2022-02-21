class NewLinkHistoryTable < ActiveRecord::Migration[7.0]
  def change
    create_table :past_links do |t|
      t.references :link, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :post_url
      t.string :post_thumbnail_url

      t.timestamps
    end
  end
end
