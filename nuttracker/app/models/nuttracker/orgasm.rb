module Nuttracker
  class Orgasm < ApplicationRecord
    belongs_to :user
    belongs_to :caused_by, foreign_key: :caused_by_user_id, class_name: 'User', optional: true

    validate :user_not_cumming_too_fast
    validates :rating, presence: true

    def user_not_cumming_too_fast
      most_recent = user.orgasms.maximum(:created_at)
      if (most_recent != nil && (most_recent.after? 5.minutes.ago))
        errors.add :caused_by, "You're cumming too fast!"
      end
    end
  end
end
