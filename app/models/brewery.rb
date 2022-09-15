class Brewery < ApplicationRecord
  has_many :beers, dependent: :destroy
  has_many :ratings, through: :beers

  def average_rating
    ratings.sum(&:score).to_f / ratings.count
  end
end
