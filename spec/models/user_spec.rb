require 'rails_helper'

RSpec.describe User, type: :model do
  it "has the username set correctly" do
    user = User.new username: "Pekka"

    expect(user.username).to eq("Pekka")
  end

  describe "is not validated or saved" do
    it "without a password" do
      user = User.create username: "Pekka"
  
      expect(user).not_to be_valid
      expect(User.count).to eq(0)
    end
  
    it "with a short password" do
      user = User.create username: "Pekka", password: "A1", password_confirmation: "A1"
      
      expect(user).not_to be_valid
      expect(User.count).to eq(0)
    end
    
    it "with a lowercase password" do
      user = User.create username: "Pekka", password: "abcdef", password_confirmation: "abcdef"
      
      expect(user).not_to be_valid
      expect(User.count).to eq(0)
    end    
  end

  describe "with a proper password" do
    let(:user){ FactoryBot.create(:user) }

    it "is saved" do
      expect(user).to be_valid
      expect(User.count).to eq(1)
    end

    it "and with two ratings, has the correct average rating" do
      FactoryBot.create(:rating, score: 10, user: user)
      FactoryBot.create(:rating, score: 20, user: user)

      expect(user.ratings.count).to eq(2)
      expect(user.average_rating).to eq(15.0)
    end
  end

  describe "favorite beer" do
    let(:user){ FactoryBot.create(:user) }
  
    it "has method for determining one" do
      expect(user).to respond_to(:favorite_beer)
    end
  
    it "without ratings does not have one" do
      expect(user.favorite_beer).to eq(nil)
    end

    it "is the only rated if only one rating" do
      beer = create_beer_with_rating({ user: user }, 20)
    
      expect(user.favorite_beer).to eq(beer)
    end

    it "is the one with highest rating if several rated" do
      create_beers_with_many_ratings({ user: user }, 10, 20, 15, 7, 9)
      best = create_beer_with_rating({ user: user }, 25 )

      expect(user.favorite_beer).to eq(best)
    end
  end

  describe "favorite style" do
    let(:user){ FactoryBot.create(:user) }

    it "has method for determining one" do
      expect(user).to respond_to(:favorite_style)
    end

    it "without ratings does not have one" do
      expect(user.favorite_style).to eq(nil)
    end

    it "is the only rated beer's style if only one rating" do
      only = create_beer_with_rating({ user: user }, 25)

      expect(user.favorite_style).to eq(only.style)
    end

    it "is the one with the highest average rating if several rated" do
      create_beers_with_many_ratings({ user: user, beer_overrides: { style: "Lager" }}, 5, 10, 10)
      create_beers_with_many_ratings({ user: user, beer_overrides: { style: "IPA" }}, 20, 40)

      expect(user.favorite_style).to eq("IPA")
    end
  end

  describe "favorite brewery" do
    let(:user){ FactoryBot.create(:user) }
    let(:cool_brewery){ FactoryBot.create(:brewery, { name: "Matin Superpanimo" }) }
    let(:bad_brewery){ FactoryBot.create(:brewery, { name: "Kaljakeisari" }) }

    it "has method for determining one" do
      expect(user).to respond_to(:favorite_brewery)
    end

    it "without ratings does not have one" do
      expect(user.favorite_brewery).to eq(nil)
    end

    it "is the only rated beer's brewery if only one rating" do
      only = create_beer_with_rating({ user: user }, 25)

      expect(user.favorite_brewery).to eq(only.brewery)
    end

    it "is the one with the highest average rating if several rated" do
      create_beers_with_many_ratings({ user: user, beer_overrides: { brewery: bad_brewery }}, 5, 10, 10)
      create_beers_with_many_ratings({ user: user, beer_overrides: { brewery: cool_brewery }}, 20, 40)

      expect(user.favorite_brewery).to eq(cool_brewery)
    end
  end
end

def create_beer_with_rating(object, score)
  beer = FactoryBot.create(:beer, object[:beer_overrides])
  FactoryBot.create(:rating, beer: beer, score: score, user: object[:user] )
  beer
end

def create_beers_with_many_ratings(object, *scores)
  scores.each do |score|
    create_beer_with_rating(object, score)
  end
end
