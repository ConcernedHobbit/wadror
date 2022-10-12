class User < ApplicationRecord
  include RatingAverage

  has_secure_password

  has_many :ratings, dependent: :destroy
  has_many :beers, through: :ratings
  has_many :memberships, dependent: :destroy
  has_many :beer_clubs, through: :memberships

  validates :username, uniqueness: true,
                       length: { minimum: 3, maximum: 30 }

  validates :password, length: { minimum: 4 }
  validates :password, format: { with: /[A-Z]/, message: "must contain uppercase letter" }
  validates :password, format: { with: /\d/, message: "must contain digit" }

  def favorite_beer
    return nil if ratings.empty?

    ratings.order(score: :desc).limit(1).first.beer
  end

  def favorite_style
    return nil if ratings.empty?

    beers.map { |beer| [beer.style, beer.ratings.map(&:score)] } # Map to [style, [...ratings]]
         .group_by(&:shift) # Group by the style while shifting it away, leaving [[...ratings]] for each style
         .transform_values(&:flatten) # Flatten the ratings for each style, leaving hash with style and corresponding ratings
         .transform_values { |ratings| ratings.sum / ratings.size } # Average ratings for each style
         .max_by(&:last).first # Find the name of the style with the maximum average
  end

  def favorite_brewery
    return nil if ratings.empty?

    beers.map { |beer| [beer.brewery, beer.ratings.map(&:score)] } # Map to [brewery, [...ratings]]
         .group_by(&:shift) # Group by the brewery while shifting it away, leaving [[...ratings]] for each style
         .transform_values(&:flatten) # Flatten the ratings for each brewery, leaving hash with brewery and corresponding ratings
         .transform_values { |ratings| ratings.sum / ratings.size } # Average ratings for each brewery
         .max_by(&:last).first # Find brewery with the maximum average
  end
end
