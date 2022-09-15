module RatingAverage
  extend ActiveSupport::Concern

  def average_rating
    return 0 if ratings.empty?

    ratings.sum(&:score).to_f / ratings.count
  end
end
