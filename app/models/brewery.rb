class Brewery < ApplicationRecord
  include RatingAverage

  has_many :beers, dependent: :destroy
  has_many :ratings, through: :beers

  validates :name, presence: true
  validate :year_must_be_in_range

  def year_must_be_in_range
    current_year = Date.today.year

    return unless !year.present? || year < 1040 || year > current_year

    errors.add(:year, "must be between 1040 and #{current_year}")
  end
end
