class Brewery < ApplicationRecord
  has_many :beers, dependent: :destroy
  has_many :ratings, through: :beers

  validates :year, numericality: { greater_than_or_equal_to: 1040,
    less_than_or_equal_to: 2018,
    only_integer: true }
  validates :name, presence: true

  def print_report
    puts name
    puts "established at year #{year}"
    puts "number of beers #{beers.count}"
  end

  def restart
    self.year = 2018
    puts "changed year to #{year}"
  end

  def to_s
    name.to_s
  end

  include RatingAverage
  # def average_rating
  #     avg = ratings.map{|rating| rating.score}.reduce(:+) / (ratings.count*1.0)
  #     return avg
  # end
end
