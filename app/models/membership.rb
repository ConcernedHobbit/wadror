class Membership < ApplicationRecord
  belongs_to :user
  belongs_to :beer_club

  validate :unique_membership

  def unique_membership
    errors.add(:user, "already part of this club") if Membership.find_by(
      beer_club_id: beer_club.id,
      user_id: user.id
    )
  end
end
