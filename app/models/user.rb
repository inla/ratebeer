class User < ApplicationRecord
  include RatingAverage

  has_many :ratings
  has_many :beers, through: :ratings
  has_secure_password

  validates :username, uniqueness: true,
                       length: { minimum: 3, maximum: 30 }
  validates :password, length: { minimum: 4 }
  # format: { with: \A[A-Z]+[a-z]+\z }

  has_many :ratings # käyttäjällä on monta ratingia

  def to_s
    username.to_s
  end
end
