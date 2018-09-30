class User < ApplicationRecord
  include RatingAverage

  has_many :ratings, dependent: :destroy
  has_many :beers, through: :ratings, dependent: :destroy
  has_secure_password

  validates :username, uniqueness: true,
                       length: { minimum: 3, maximum: 30 }
  validates :password, length: { minimum: 4 }
  #    format: { with: /[A-Z].*\d|\d.*[A-Z]/,
  #    format: { with: /(?=.*\d+)(?=.*[A-Z]+)/,
  #    message: "must contain one capital letter and number" }

  def to_s
    username.to_s
  end

  def favorite_beer
    return nil if ratings.empty?

    ratings.order(score: :desc).limit(1).first.beer
  end

  def favorite_style
    return nil if ratings.empty?

    ratings_by_style = ratings.group_by{ |r| r.beer.style }
    ratings_by_style.keys.max_by{ |i| average(ratings_by_style[i].map(&:score)) }
  end

  def favorite_brewery
    return nil if ratings.empty?

    ratings_by_brewery = ratings.group_by{ |r| r.beer.brewery }
    ratings_by_brewery.keys.max_by{ |i| average(ratings_by_brewery[i].map(&:score)) }
  end

  def average(arr)
    size = arr.count
    return nil if size.zero?

    sum = arr.reduce(0.0){ |total, i| total + i }
    sum / size
  end
end
