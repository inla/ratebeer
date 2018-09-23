class User < ApplicationRecord
  include RatingAverage

  has_many :ratings
  has_many :beers, through: :ratings, dependent: :destroy
  has_secure_password

  validates :username, uniqueness: true,
                       length: { minimum: 3, maximum: 30 }
  validates :password, length: { minimum: 4 }
                       format: { with: /[A-Z].*\d|\d.*[A-Z]/,
                       message: "must contain one capital letter and number" }

  def to_s
      username.to_s
  end
  end
