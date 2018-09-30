require 'rails_helper'

include Helpers

describe "User" do
  before :each do
    @user = FactoryBot.create(:user, username:'Pekka', password:'Foobar1')
  end

  describe "who has signed up" do
    it "can signin with right credentials" do
      sign_in(username:"Pekka", password:"Foobar1")

      expect(page).to have_content 'Welcome back!'
      expect(page).to have_content 'Pekka'
    end

    it "is redirected back to signin form if wrong credentials given" do
      sign_in(username:"Pekka", password:"wrong")

      expect(current_path).to eq(signin_path)
      expect(page).to have_content 'Username and/or password mismatch'
    end

  end

  it "when signed up with good credentials, is added to the system" do
    visit signup_path
    fill_in('user_username', with:'Brian')
    fill_in('user_password', with:'Secret55')
    fill_in('user_password_confirmation', with:'Secret55')
  
    expect{
      click_button('Create User')
    }.to change{User.count}.by(1)
  end

  it "can delete own ratings" do
    brewery = FactoryBot.create(:brewery)
    beer = FactoryBot.create(:beer, brewery: brewery)
    rating = FactoryBot.create(:rating, beer: beer, user: @user, score:30)        
    visit user_path(@user)
    sign_in(username:"Pekka", password:"Foobar1")
    visit user_path(@user)
    expect(page).to have_content('delete')
    expect{ click_link('delete', href: rating_path(rating)) }.to change{ Rating.where(user: @user).count }.by(-1)
  end

  describe "User's page" do
    before :each do
      visit user_path(@user)
    end

    it "doesn't show other's ratings" do
      user2 = FactoryBot.create(:user, username: 'toinen', password:'Joku1', password_confirmation:'Joku1')
      brewery = FactoryBot.create(:brewery)
      beer = FactoryBot.create(:beer, brewery: brewery)
      FactoryBot.create(:rating, beer: beer, user: user2, score:10)
      visit user_path(@user)
      save_and_open_page
      expect(page).to have_no_content("10 ratings")
    end

      before :each do
        brewery = FactoryBot.create(:brewery)
        beer = FactoryBot.create(:beer, brewery: brewery)
        @rating = FactoryBot.create(:rating, beer: beer, user: @user, score:20)        
        visit user_path(@user)
      end

      it "shows user's ratings" do
        expect(page).to have_content('1 rating')
        expect(page).to have_content(@rating.beer)
        expect(page).to have_content(@rating.score)
      end

      it "shows favorite beer style" do
        expect(page).to have_content(@user.favorite_style)
      end

      it "shows favorite brewery" do
        expect(page).to have_content(@user.favorite_brewery.name)
      end
  end

end