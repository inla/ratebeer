require 'rails_helper'

describe "Places" do
  it "if one is returned by the API, it is shown at the page" do
    allow(BeermappingApi).to receive(:places_in).with("kumpula").and_return(
      [ Place.new( name:"Oljenkorsi", id: 1 ) ]
    )

    visit places_path
    fill_in('city', with: 'kumpula')
    click_button "Search"

    expect(page).to have_content "Oljenkorsi"
  end

  it "if several are returned by the API, they are all shown at the page" do
    allow(BeermappingApi).to receive(:places_in).with("kivenlahti").and_return(
        [ Place.new( name:"Nousuvesi", id: 1 ), Place.new( name:"STV", id: 2 ), Place.new( name:"Tyrsky", id: 3 ) ]
      )
  
      visit places_path
      fill_in('city', with: 'kivenlahti')
      click_button "Search"
  
      expect(page).to have_content "Nousuvesi"
      expect(page).to have_content "STV"
      expect(page).to have_content "Tyrsky"
  end
  
  it "if none are returned by the API, notification is shown at the page" do
    allow(BeermappingApi).to receive(:places_in).with("saunalahti").and_return([])

    visit places_path
    fill_in('city', with: 'saunalahti')
    click_button "Search"

    expect(page).to have_content "No locations in saunalahti"
  end
end