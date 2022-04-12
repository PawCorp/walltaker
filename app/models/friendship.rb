class Friendship < ApplicationRecord
  belongs_to :sender, foreign_key: :sender_id, class_name: 'User'
  belongs_to :receiver, foreign_key: :receiver_id, class_name: 'User', optional: true
  validates :sender_id, uniqueness: { scope: [:receiver_id] }

  def self.find_friendship(person_a, person_b)
    self.where(sender_id: [person_a.id, person_b.id], receiver_id: [person_b.id, person_a.id], confirmed: true)
  end
end
