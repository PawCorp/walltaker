class Kink < ApplicationRecord
  validates_uniqueness_of :name
  validates_length_of :name, maximum: 30, minimum: 1

  normalizes :name, with: -> name { name.titleize.gsub(/[^\w\d_]/, '').underscore }

  has_many :kink_havers
  has_many :users, through: :kink_havers
end
