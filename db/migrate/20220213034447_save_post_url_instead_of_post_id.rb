class SavePostUrlInsteadOfPostId < ActiveRecord::Migration[7.0]
  def change
    add_column :links, :post_url, :string
    add_column :links, :post_thumbnail_url, :string
    add_column :links, :post_description, :string
    remove_column :links, :currentImage
  end
end
