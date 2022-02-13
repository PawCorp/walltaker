class AddCurrentImageToLink < ActiveRecord::Migration[7.0]
  def change
    add_column :links, :currentImage, :integer
  end
end
