class Kink < ApplicationRecord
  validates_uniqueness_of :name
  validates_length_of :name, maximum: 30, minimum: 1

  normalizes :name, with: -> name { name.gsub(/[^\w\d_\-\(\)\/\s]/, '').strip.squish.gsub(/\s/, '_') }

  has_many :kink_havers
  has_many :users, through: :kink_havers
end
