class MessageThread < ApplicationRecord
  has_many :message_thread_participants
  has_many :users, through: :message_thread_participants
  has_many :messages

  def on_new_message
    broadcast_update partial: 'message_thread/messages_from_thread'
  end
end
