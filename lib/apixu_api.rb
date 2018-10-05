class ApixuApi
  def self.weather_in(city)
    city = city.downcase

    # weather = Rails.cache.read(city)
    # return weather if weather

    weather = get_weather_in(city)
    # Rails.cache.write(city, weather)
    weather
    # Rails.cache.fetch(city, expires_in: 1.hour) { get_weather_in(city) }
  end

  def self.get_weather_in(city)
    url = "https://api.apixu.com/v1/current.json?key=#{key}&q="

    response = HTTParty.get "#{url}#{ERB::Util.url_encode(city)}"
    return nil if response["error"]

    Weather.new(
      loc: response["location"]["name"],
      temp: response["current"]["temp_c"],
      icon: "https:#{response['current']['condition']['icon']}",
      wind: response["current"]["wind_kph"] / 3.6,
      wind_d: response["current"]["wind_dir"]
    )
  end

  def self.key
    raise "APIXU_APIKEY env variable not defined" if ENV['APIXU_APIKEY'].nil?

    ENV['APIXU_APIKEY']
  end
end
