class CreateCachedPosts < ActiveRecord::Migration[7.0]
  def change
    create_table :cached_posts do |t|
      t.bigint :post_id
      t.string :url

      t.timestamps
    end
  end
end
