class BeerClub < ApplicationRecord
  has_many :users, through: :memberships
end
