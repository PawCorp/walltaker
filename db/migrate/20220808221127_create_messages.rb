class CreateMessages < ActiveRecord::Migration[7.0]
  def change
    create_table :messages do |t|
      t.bigint :message_thread_id, null: false, foreign_key: true, foreign_key_column_for: 'message_threads'
      t.bigint :from_user_id, null: false, foreign_key: true, foreign_key_column_for: 'users'
      t.string :content

      t.timestamps
    end
  end
end
