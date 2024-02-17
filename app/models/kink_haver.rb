class KinkHaver < ApplicationRecord
  validates_uniqueness_of :kink_id, scope: :user_id

  belongs_to :user
  belongs_to :kink, inverse_of: :kink_havers
end
