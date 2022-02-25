class Link < ApplicationRecord
  belongs_to :user
  has_many :past_links
  validates :expires, presence: true, unless: :never_expires?
end
