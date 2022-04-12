class Notification < ApplicationRecord
  belongs_to :user
  enum notification_type: %i[friend_request_sent friend_request_received friend_request_they_accepted post_response]
end
