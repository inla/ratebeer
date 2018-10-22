# json.array! @breweries, partial: 'breweries/brewery', as: :brewery
json.array! @active_breweries + @retired_breweries, partial: 'breweries/brewery', as: :brewery
