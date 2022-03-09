class Link < ApplicationRecord
  belongs_to :user
  has_many :past_links
  validates :expires, presence: true, unless: :never_expires?
  validates :theme, format: { without: /\s+/i, message: 'must be only 1 tag.' }

  after_update_commit do
    broadcast_update
    if previous_changes['post_url']&.include?(post_url)
      clear_changes_information
      broadcast_replace_to "submit_link_#{id}", target: "submit_link_#{id}", partial: 'links/submit', locals: { link: self }
    end
  end
end
