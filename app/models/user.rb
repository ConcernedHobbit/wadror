class User < ApplicationRecord
  include RatingAverage

  has_many :ratings

  validates :username, uniqueness: true,
                       length: { minimum: 3, maximum: 30 }
end
