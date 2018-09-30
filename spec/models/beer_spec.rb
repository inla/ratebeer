require 'rails_helper'

RSpec.describe Beer, type: :model do
  describe "with a brewery" do
    let(:brewery){ Brewery.create name:"TestiPanimo", year:"2010" }
    describe "and with a name and style" do
      let(:beer){ Beer.new name:"TestiBisse", style: "Lager", brewery_id: brewery.id }
      
      it "is valid and saved" do
        expect(beer).to be_valid
        expect(beer.save).to be true
      end
    end

    describe "and with a style but no name" do
      let(:beer){ Beer.new style: "Lager", brewery_id: brewery.id }

      it "isn't valid or saved" do
        expect(beer).to_not be_valid
        expect(beer.save).to be false
      end
    end

    describe "and with a name but no style" do
      let(:beer){ Beer.new name:"TestiKalja", brewery_id: brewery.id }
      
      it "isn't valid or saved" do
        expect(beer).to_not be_valid
        expect(beer.save).to be false
      end
    end
  end

  # describe "when one beer exists" do
  #   it "is valid" do
  #     beer = FactoryBot.create(:beer)
  #     expect(beer).to be_valid
  #   end
  
  #   it "has the default style" do
  #     beer = FactoryBot.create(:beer)
  #     expect(beer.style).to eq("Lager")
  #   end
  # end

  describe "when one beer exists" do
    let(:beer){FactoryBot.create(:beer)}
  
    it "is valid" do
      expect(beer).to be_valid
    end
  
    it "has the default style" do
      expect(beer.style).to eq("Lager")
    end
  end

end