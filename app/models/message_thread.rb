class MessageThread < ApplicationRecord
  has_many :message_thread_participants
  has_many :users, through: :message_thread_participants
  has_many :messages

  def on_new_message
    broadcast_update partial: 'message_thread/messages_from_thread'
  end

  def self.find_common_thread(*users)
    self.joins(:message_thread_participants, :users).where(users: users).group('message_threads.id').having('count(distinct users.id) = ?', users.length).first
  end
end
