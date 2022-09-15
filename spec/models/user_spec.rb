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
end