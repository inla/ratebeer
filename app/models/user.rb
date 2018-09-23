class User < ApplicationRecord
    include RatingAverage
    
    has_many :ratings
  has_many :beers, through: :ratings

validates :username, uniqueness: true,
                       length: { minimum: 3, maximum: 30 }

  has_many :ratings   # käyttäjällä on monta ratingia

  def to_s
    "#{username}"
  end

end
