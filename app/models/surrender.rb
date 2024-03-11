class Surrender < ApplicationRecord
  belongs_to :user, inverse_of: :current_surrender, required: true
  belongs_to :friendship, required: true

  validates :user, uniqueness: { scope: :friendship }
  validates :expires_at, comparison: { greater_than: Time.now }, on: :create

  scope :not_for_user, ->(user) { where.not(user: user) }
  scope :for_user, ->(user) { find_by(user: user) }

  def controller
    friendship.other_user(user)
  end

  def expired?
    expires_at.before? Time.now
  end
end
