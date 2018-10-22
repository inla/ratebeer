class PlacesController < ApplicationController
  def index
  end

  def show
    @place = BeermappingApi.place_in(session[:city], params[:id])
  end

  def search
    city = params[:city]
    @places = BeermappingApi.places_in(city)
    if @places.empty?
      redirect_to places_path, notice: "No locations in #{city}"
    else
      @weather = ApixuApi.weather_in(city)
      session[:city] = city
      render :index
    end
  end
end
