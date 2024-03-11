class KinkHaver < ApplicationRecord
  MAXIMUM_STARRED_KINKS = 3

  validates_uniqueness_of :kink_id, scope: :user_id, message: 'must only appear once'
  validate :user_has_less_than_the_maximum_number_of_starred_kinks, on: :starring

  belongs_to :user
  belongs_to :kink, inverse_of: :kink_havers

  scope :are_starred, -> { where(is_starred: true) }

  def user_has_less_than_the_maximum_number_of_starred_kinks
    if user.kink_havers.are_starred.length >= MAXIMUM_STARRED_KINKS
      errors.add(:user, "must can only have a maximum of #{MAXIMUM_STARRED_KINKS} starred kinks")
    end
  end

  def toggle_star
    self.is_starred = !is_starred?
    if is_starred
      save(context: :starring)
    else
      save
    end
  end
end
