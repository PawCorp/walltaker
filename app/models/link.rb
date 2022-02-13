class Link < ApplicationRecord
  belongs_to :user
  validates :expires, presence: true
end
