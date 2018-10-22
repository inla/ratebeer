class Style < ApplicationRecord
  include RatingAverage
  extend RatingTop

  has_many :beers
  has_many :ratings, through: :beers

  def to_s
    name
  end
end
