class CreateSurrenders < ActiveRecord::Migration[7.1]
  def change
    create_table :surrenders do |t|
      t.references :user, null: false, foreign_key: true
      t.references :friendship, null: false, foreign_key: true
      t.timestamp :expires_at

      t.timestamps
    end
  end
end
