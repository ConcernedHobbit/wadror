require 'rails_helper'

describe "Places" do
  it "if one is returned by the API, it is shown at the page" do
    allow(BeermappingApi).to receive(:places_in).with("kumpula").and_return(
      [ Place.new( name: "Oljenkorsi", id: 1 ) ]
    )

    visit places_path
    fill_in('city', with: 'kumpula')
    click_button "Search"

    expect(page).to have_content "Oljenkorsi"
  end

  it "if multiple are returned by API, all are shown on page" do
    allow(BeermappingApi).to receive(:places_in).with("kumpula").and_return(
      [ Place.new( name: "Oljenkorsi", id: 1 ), Place.new( name: "Salakapakka", id: 2 ) ]
    )

    visit places_path
    fill_in('city', with: 'kumpula')
    click_button "Search"

    expect(page).to have_content "Oljenkorsi"
    expect(page).to have_content "Salakapakka"
  end

  it "none are returned, notice is shown on page" do
    allow(BeermappingApi).to receive(:places_in).with("porvoo").and_return(
      []
    )

    visit places_path
    fill_in('city', with: 'porvoo')
    click_button "Search"

    expect(page).to have_content "No locations in porvoo"
  end
end
