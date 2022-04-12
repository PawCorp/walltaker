class CreateNewNotificationsTable < ActiveRecord::Migration[7.0]
  def change
    create_table :new_notifications_tables do |t|
      t.references :user_id, null: false, foreign_key: true
      t.integer :type
      t.string :text
      t.string :link

      t.timestamps
    end
  end
end
