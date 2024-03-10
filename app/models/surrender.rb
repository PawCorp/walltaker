class Surrender < ApplicationRecord
  belongs_to :user, inverse_of: :current_surrender, required: true
  belongs_to :friendship, required: true

  validates :user, uniqueness: { scope: :friendship }
  validates :expires_at, comparison: { greater_than: Time.now }, on: :create

  def controller
    friendship.other_user(user)
  end
end
