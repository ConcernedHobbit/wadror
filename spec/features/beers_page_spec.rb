require 'rails_helper'

describe "Beer" do
  let!(:brewery) { FactoryBot.create :brewery, name: "Laitilan Wirvoitusjuomatehdas" }

  describe "with a logged in user" do
    before :each do
      FactoryBot.create :user
      sign_in(username: "Pekka", password: "Foobar1")
    end

    it "when added with valid name, is added to the system" do
      visit new_beer_path
      fill_in("beer_name", with: "Kukko Lager")
      select("Lager", from: "beer[style]")
      select("Laitilan Wirvoitusjuomatehdas", from: "beer[brewery_id]")
  
      expect {
        click_button "Create Beer"
      }.to change{Beer.count}.from(0).to(1)
  
      expect(brewery.beers.count).to eq(1)
    end
  
    it "when added with invalid name, shows correct error message" do
      visit new_beer_path
      # Don't fill in name
      select("Lager", from: "beer[style]")
      select("Laitilan Wirvoitusjuomatehdas", from: "beer[brewery_id]")
  
      click_button "Create Beer"
  
      expect(page).to have_content "Name can't be blank"
    end
  end
end