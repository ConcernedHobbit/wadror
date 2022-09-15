require 'rails_helper'

RSpec.describe Beer, type: :model do
  let(:test_brewery) { Brewery.create name: "test", year: 2000 }

  it "is saved when given details" do
    beer = Beer.create name: "testiolut", style: "testityyli", brewery_id: test_brewery.id

    expect(beer).to be_valid
    expect(Beer.count).to eq (1)
  end

  describe "is not saved" do 
    it "without a name" do
      beer = Beer.create style: "testityyli", brewery_id: test_brewery.id
      
      expect(beer).not_to be_valid
      expect(Beer.count).to eq (0)
    end
    
    it "without a style" do
      beer = Beer.create name: "testiolut", brewery_id: test_brewery.id

      expect(beer).not_to be_valid
      expect(Beer.count).to eq (0)
    end
  end
end
