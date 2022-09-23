class LinkAbility < ApplicationRecord
  belongs_to :link
  enum :ability, {can_show_videos: 'can_show_videos'}
end
