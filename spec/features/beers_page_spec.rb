require 'rails_helper'

include Helpers

describe "Beer" do

  describe "with a valid style and brewery" do
    before :each do
      FactoryBot.create(:user, username:"User", password:"User1", password_confirmation:"User1")
      sign_in(username: "User", password:"User1")
      FactoryBot.create(:brewery, name:'Panimo')
      visit new_beer_path
      select('Lager', from:'beer_style')
      select('Panimo', from:'beer_brewery_id')
    end

    it "can be created if name isn't empty" do
      fill_in('beer_name', with:'TestiBisse')
      expect{ click_button "Create Beer" }.to change{Beer.count}.by(1)
    end

    it "can't be created, if name is empty" do
      expect{ click_button "Create Beer" }.to change{Beer.count}.by(0)
    end
  end
end