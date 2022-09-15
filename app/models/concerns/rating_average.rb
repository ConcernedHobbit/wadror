module RatingAverage
  extend ActiveSupport::Concern
 
  def average_rating
    ratings.sum(&:score).to_f / ratings.count
  end
 end