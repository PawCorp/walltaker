class BannedIp < ApplicationRecord
  belongs_to :banned_by, foreign_key: :banned_by_id, class_name: 'User'
end
