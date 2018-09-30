require 'rails_helper'

RSpec.describe User, type: :model do
  it "has the username set correctly" do
    user = User.new username:"Pekka"

    expect(user.username).to eq("Pekka")
  end

  it "is not saved without a password" do
    user = User.create username:"Pekka"

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  describe "with a proper password" do
    let(:user) { FactoryBot.create(:user) }
  
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
  
    describe "with a proper username" do
      let(:user){ User.create username:"Paavo" }
  
      # it "doesn't validate or save only alphabetical passwords" do
      #   user.password = "AaaAaaA"
  
      #   # not_valid_and_isnt_saved(user)
      #   expect(user).not_to be_valid
      #   expect(user.save).to be false
      # end
  
      it "doesn't validate or save too short passwords" do
        user.password = "Aa1"
        expect(user).not_to be_valid
        expect(user.save).to be false  
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
        beer = FactoryBot.create(:beer)
        rating = FactoryBot.create(:rating, score: 20, beer: beer, user: user)
  
        expect(user.favorite_beer).to eq(beer)
      end  
      
      it "is the one with highest rating if several rated" do
        create_beers_with_many_ratings({user: user}, 10, 20, 15, 7, 9)
        best = create_beer_with_rating({ user: user }, 25 )
  
        expect(user.favorite_beer).to eq(best)
      end    
    end

    # describe "the application" do
    #   it "does something with two users" do
    #     user1 = FactoryBot.create(:user)
    #     user2 = FactoryBot.create(:user, username: "Vilma")
    
    #   # ...
    #   end
    # end

    describe "favourite" do
      let(:user){ FactoryBot.create(:user) }

    describe "style" do

      it "has method for determining one" do
        expect(user).to respond_to(:favorite_style)
      end
    
      it "without ratings does not have one" do
        expect(user.favorite_style).to eq(nil)
      end

      it "is the only rated if only one style rated" do
        style = "Lager"
        beer = FactoryBot.create(:beer, style: style)
        rating = FactoryBot.create(:rating, score: 20, beer: beer, user: user)
      
        expect(user.favorite_style).to eq style
      end

      it "is the one with highest rated beer, if beers of several styles rated" do
        eka = "Ipa"
        toka = "Apa"
        ekaa = FactoryBot.create(:beer, style: eka)
        tokaa = FactoryBot.create(:beer, style: toka)

        FactoryBot.create(:rating, score: 20, beer: ekaa, user: user)
        FactoryBot.create(:rating, score: 10, beer: tokaa, user: user)

        expect(user.favorite_style).to eq eka
      end

      it "otherwise is the one with the highest average rating" do
        eka = "Ipa"
        toka = "Apa"
        ekanratet = [11,15,20]
        tokanratet = [1,8,20]
        create_beers_with_style_and_many_ratings({user: user},eka, ekanratet)
        create_beers_with_style_and_many_ratings({user: user},toka, tokanratet)
        expect(user.favorite_style).to eq eka
      end
    end

  describe "brewery" do
    
    it "has method for determining one" do
      expect(user).to respond_to(:favorite_brewery)
    end
  
    it "without ratings does not have one" do
      expect(user.favorite_brewery).to eq(nil)
    end

    it "is the only rated if only one brewery rated" do
      brewery = FactoryBot.create(:brewery)
      beer = FactoryBot.create(:beer, brewery: brewery)
      rating = FactoryBot.create(:rating, score: 20, beer: beer, user: user)
    
      expect(user.favorite_brewery).to eq brewery
    end

    it "is the one with highest rated beer, if two beers of two breweries rated" do
      brew1 = FactoryBot.create(:brewery, name: "Brewery1")
      brew2 = FactoryBot.create(:brewery, name: "Brewery2")
      brew1beer = FactoryBot.create(:beer, brewery: brew1)
      brew2beer = FactoryBot.create(:beer, brewery: brew2)

      FactoryBot.create(:rating, score: 20, beer: brew1beer, user: user)
      FactoryBot.create(:rating, score: 10, beer: brew2beer, user: user)

      expect(user.favorite_brewery).to eq brew1
    end

    it "otherwise is the one with the highest average rating" do
      brew1 = FactoryBot.create(:brewery, name: "Brewery1")
      brew2 = FactoryBot.create(:brewery, name: "Brewery2")
      brew1scores = [15,20,25]
      brew2scores = [1,5,11]
      create_beers_with_brewery_and_many_ratings({user: user},brew1, brew1scores)
      create_beers_with_brewery_and_many_ratings({user: user},brew2, brew2scores)
      expect(user.favorite_brewery).to eq brew1
    end
  end
end
  end # describe User
  
  def create_beer_with_rating(object, score)
    beer = FactoryBot.create(:beer)
    FactoryBot.create(:rating, beer: beer, score: score, user: object[:user] )
    beer
  end
  
  def create_beers_with_many_ratings(object, *scores)
    scores.each do |score|
      create_beer_with_rating(object, score)
    end
  end

  def create_beers_with_style_and_many_ratings(object, style, scores)
    scores.each do |score|
      create_beer_with_style_and_rating(object, style, score)
    end
  end

  def create_beer_with_style_and_rating(object, style, score)
    beer = FactoryBot.create(:beer, style: style)
    FactoryBot.create(:rating, beer: beer, score: score, user: object[:user])
    beer
  end

  def create_beers_with_brewery_and_many_ratings(object, brewery, scores)
    scores.each do |score|
      create_beer_with_brewery_and_rating(object, brewery, score)
    end
  end

  def create_beer_with_brewery_and_rating(object, brewery, score)
    beer = FactoryBot.create(:beer, brewery: brewery)
    FactoryBot.create(:rating, beer: beer, score: score, user: object[:user])
    beer
  end