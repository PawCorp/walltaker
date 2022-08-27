class MessageThread < ApplicationRecord
  has_many :message_thread_participants
  has_many :users, through: :message_thread_participants
  has_many :messages
end
