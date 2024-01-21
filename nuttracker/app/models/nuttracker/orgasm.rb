module Nuttracker
  class Orgasm < ApplicationRecord
    validate :user_not_cumming_too_fast

    belongs_to :user
    validates :rating, presence: true
    belongs_to :caused_by, foreign_key: :caused_by_user_id, class_name: 'User', optional: true

    def user_not_cumming_too_fast
      most_recent = user.orgasms.maximum(:created_at)
      if (most_recent != nil && (most_recent.after? 15.minutes.ago))
        errors.add :base, "You're cumming too fast!"
      end
    end
  end
end
