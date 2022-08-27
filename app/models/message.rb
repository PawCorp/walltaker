class Message < ApplicationRecord
  belongs_to :message_thread, class_name: 'MessageThread'
  belongs_to :from_user, class_name: 'User'

  after_commit do
    message_thread.on_new_message
  end
end
