class CreateNewNotificationsTable < ActiveRecord::Migration[7.0]
  def change
    create_table :notifications do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :notification_type
      t.string :text
      t.string :link

      t.timestamps
    end
  end
end
