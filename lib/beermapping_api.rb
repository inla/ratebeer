class BeermappingApi
  def self.places_in(city)
    city = city.downcase
    Rails.cache.fetch(city, expires_in: 1.week) { get_places_in(city) }
  end

  def self.get_places_in(city)
    url = "http://beermapping.com/webservice/loccity/#{key}/"

    response = HTTParty.get "#{url}#{ERB::Util.url_encode(city)}"
    places = response.parsed_response["bmp_locations"]["location"]

    return [] if places.is_a?(Hash) && places['id'].nil?

    places = [places] if places.is_a?(Hash)
    places.map do |place|
      Place.new(place)
    end
  end

  def self.key
    raise "BEERMAPPING_APIKEY env variable not defined" if ENV['BEERMAPPING_APIKEY'].nil?

    ENV['BEERMAPPING_APIKEY']
    # "e2530b410dc9d9aceeb2bbb3a2dfa133" # "731955affc547174161dbd6f97b46538"
  end

  def self.place(pid)
    place = Rails.cache.read(pid)
    return place if place

    place = get_place(pid)
    Rails.cache.write(pid, place, expires_in: 1.day)
    place
    # Rails.cache.fetch(id, expires_in: 1.day) { get_place(id) }
  end

  def self.get_place(pid)
    url = "http://beermapping.com/webservice/locquery/#{key}/#{pid}"
    response = HTTParty.get url
    place = response.parsed_response["bmp_locations"]["location"]
    Place.new(place)
  end
end
