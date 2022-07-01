module Nuttracker
  class Orgasm < ApplicationRecord
    belongs_to :user
    validates :rating, presence: true
  end
end
