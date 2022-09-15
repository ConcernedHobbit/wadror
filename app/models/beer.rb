class Beer < ApplicationRecord
  belongs_to :brewery
  has_many :ratings

  def average_rating
    ratings.sum(&:score).to_f / ratings.count
  end
end
