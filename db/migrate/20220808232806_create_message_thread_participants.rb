class CreateMessageThreadParticipants < ActiveRecord::Migration[7.0]
  def change
    create_table :message_thread_participants do |t|
      t.bigint :message_thread_id, null: false, foreign_key: true, foreign_key_column_for: 'message_threads'
      t.bigint :user_id, null: false, foreign_key: true, foreign_key_column_for: 'users'

      t.timestamps
    end
  end
end
