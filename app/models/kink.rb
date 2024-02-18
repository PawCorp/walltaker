class Kink < ApplicationRecord
  validates_uniqueness_of :name
  validates_length_of :name, maximum: 30, minimum: 1

  normalizes :name, with: -> name { name.gsub(/[^\w\d_\-\(\)\/\s]/, '').strip.squish.downcase.gsub(/\s/, '_') }

  has_many :kink_havers
  has_many :users, through: :kink_havers

  def test_on_e621
    begin
      result = ApplicationController.new.get_tag_results(name, nil, nil, nil, 1);
    rescue
      result = nil
    end

    if result && result.length > 0
      self.works_on_e621 = true
    else
      self.works_on_e621 = false
    end

    save
  end
end
