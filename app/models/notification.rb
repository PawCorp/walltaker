class Notification < ApplicationRecord
  belongs_to :user

  enum type: %i[friend_request_sent friend_request_received friend_request_you_accepted friend_request_they_accepted post_response]
end
