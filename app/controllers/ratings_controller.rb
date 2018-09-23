class RatingsController < ApplicationController
  def index
    @ratings = Rating.all
  end

  def new
    @rating = Rating.new
    @beers = Beer.all
  end

  def create
    @rating = Rating.new params.require(:rating).permit(:score, :beer_id)
    @rating.user = current_user
  
    if @rating.save
      redirect_to user_path current_user
    else
      @beers = Beer.all
      render :new
    end
  end

  def destroy
    rating = Rating.find(params[:id])
    rating.delete
    redirect_to user_path(current_user)
  end

  def create
    # otetaan luotu reittaus muuttujaan
    rating = Rating.create params.require(:rating).permit(:score, :beer_id)
  
    # talletetaan tehty reittaus sessioon
    session[:last_rating] = "#{rating.beer.name} #{rating.score} points"
  
    redirect_to ratings_path
  end

end
