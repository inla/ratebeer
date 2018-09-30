require 'rails_helper'

include Helpers

describe "Rating" do
  let!(:brewery) { FactoryBot.create :brewery, name:"Koff" }
  let!(:beer1) { FactoryBot.create :beer, name:"iso 3", brewery:brewery }
  let!(:beer2) { FactoryBot.create :beer, name:"Karhu", brewery:brewery }
  let!(:user) { FactoryBot.create :user }

  before :each do
    sign_in(username:"Pekka", password:"Foobar1")
  end

  it "when given, is registered to the beer and user who is signed in" do
    visit new_rating_path
    select('iso 3', from:'rating[beer_id]')
    fill_in('rating[score]', with:'15')

    expect{
      click_button "Create Rating"
    }.to change{Rating.count}.from(0).to(1)

    expect(user.ratings.count).to eq(1)
    expect(beer1.ratings.count).to eq(1)
    expect(beer1.average_rating).to eq(15.0)
  end

  describe "Ratings page" do
  
    it "shows rating count and ratings" do
      FactoryBot.create(:rating, beer: beer1, user: user, score: 15)
      visit ratings_path
      save_and_open_page
      expect(page).to have_content('1 rating')
      expect(page).to have_content('iso 3')
      expect(page).to have_content('15')
      expect(page).to have_content('Pekka')
      save_and_open_page
    end
  end
end