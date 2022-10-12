require 'rails_helper'

include Helpers

describe "Rating" do
  let!(:brewery) { FactoryBot.create :brewery, name: "Koff" }
  let!(:beer1) { FactoryBot.create :beer, name: "iso 3", brewery:brewery }
  let!(:beer2) { FactoryBot.create :beer, name: "Karhu", brewery:brewery }
  let!(:user) { FactoryBot.create :user }
  let!(:user2) { FactoryBot.create :user, username: "Kalevi" }

  before :each do
    sign_in(username: "Pekka", password: "Foobar1")
  end

  it "when given, is registered to the beer and user who is signed in" do
    visit new_rating_path
    select("iso 3", from: "rating[beer_id]")
    fill_in("rating[score]", with: "15")

    expect{
      click_button "Create Rating"
    }.to change{Rating.count}.from(0).to(1)

    expect(user.ratings.count).to eq(1)
    expect(beer1.ratings.count).to eq(1)
    expect(beer1.average_rating).to eq(15.0)
  end

  it "should not be listed before any created" do
    visit ratings_path
    expect(page).to have_content "List of ratings"
    expect(page).to have_content "Total ratings: 0"
  end

  describe "when ratings exist" do
    before :each do
      create_beers_with_many_ratings({ user: user, beer_overrides: { name: "Olvi" } }, 10, 20, 15, 7, 9)
    end

    it "they should be listed on ratings page" do
      visit ratings_path
      expect(page).to have_content "Total ratings: 5"
      expect(page).to have_content "Olvi 20"
    end

    it "they should be visible on user's page" do
      visit user_path(user)
      expect(page).to have_content "Olvi 20"
    end

    it "they should not be visible on other users' pages" do
      visit user_path(user2)
      expect(page).not_to have_content "Olvi 20"
    end

    it "user's page should reflect favourite brewery and style" do
      visit user_path(user)
      expect(page).to have_content "Favorite style: Lager"
      expect(page).to have_content "Favorite brewery: anonymous"
    end
  end
end