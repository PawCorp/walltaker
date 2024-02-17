class KinkHaver < ApplicationRecord
  belongs_to :user
  belongs_to :kink, inverse_of: :kink_havers
end
