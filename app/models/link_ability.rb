class LinkAbility < ApplicationRecord
  belongs_to :link
  enum :ability, {
    can_show_videos: 'can_show_videos',
    can_be_set_by_porn_bot: 'can_be_set_by_porn_bot',
    can_be_set_by_lizard: 'can_be_set_by_lizard'
  }
end
