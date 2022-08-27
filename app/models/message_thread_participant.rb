class MessageThreadParticipant < ApplicationRecord
  belongs_to :user
  belongs_to :message_thread
end
