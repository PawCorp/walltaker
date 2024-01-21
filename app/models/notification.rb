class Notification < ApplicationRecord
  belongs_to :user
  enum notification_type: %i[friend_request_sent friend_request_received friend_request_they_accepted post_response added_to_message_thread new_message orgasm_credited_to_you]

  after_commit do
    broadcast_replace_to "header_notifications_#{user.id}", target: "header_notifications", partial: 'notifications', locals: { notifications: Notification.all.where(user: user).order(id: :desc).limit(5) }
  end
end
