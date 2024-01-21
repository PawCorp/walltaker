class Friendship < ApplicationRecord
  belongs_to :sender, foreign_key: :sender_id, class_name: 'User'
  belongs_to :receiver, foreign_key: :receiver_id, class_name: 'User', optional: true

  validate :friendship_does_not_already_exist
  validates :receiver_id, comparison: { other_than: :sender_id, message: ->(friendship, data) { "You can\'t be friends with yourself, on walltaker at least." } }

  scope :involving, ->(user) { where(sender_id: user.id).or(where(sender_id: user.id)) }
  scope :is_confirmed, ->() { where(confirmed: true) }
  scope :is_request, ->() { where(confirmed: [nil, false]) }

  def self.find_friendship(person_a, person_b)
    self.find_friendship_request(person_a, person_b).is_confirmed
  end

  def self.find_friendship_request(person_a, person_b)
    self.where(sender_id: [person_a.id, person_b.id], receiver_id: [person_b.id, person_a.id])
  end

  def friendship_does_not_already_exist
    existing_friendship = Friendship.find_friendship_request(sender, receiver).first
    if existing_friendship.present?
      if existing_friendship.confirmed?
        errors.add(:receiver_id, "You're already friends!")
      else
        if existing_friendship.id != self.id
          if existing_friendship.sender_id == self.sender_id
            errors.add(:receiver_id, "#{existing_friendship.receiver.username} has not accepted a friend request you already sent. You can cancel it and resend it in the 'Friends' tab. They will get another notification. Don't be a dick.")
          else
            errors.add(:receiver_id, "You already have a pending friend request from #{existing_friendship.sender.username}! You can accept it in the 'Friends' tab.")
          end
        end
      end
    end
  end

  def other_user(user)
    return sender if sender.id != user.id
    receiver if receiver.id != user.id
  end
end
