class Beer < ApplicationRecord
  include RatingAverage

  belongs_to :brewery
  has_many :ratings, dependent: :destroy
  has_many :raters, through: :ratings, source: :user
  #   has_many :raters, -> { distinct }, through: :ratings, source: :user

  validates :name, presence: true
  validates :style, presence: true

  #   def average_rating
  #     sum = 0.0
  #     ratings.each {|rating| sum += rating.score}
  #     avg = sum / ratings.count

  #     avg = ratings.map{|rating| rating.score}.reduce(:+) / (ratings.count*1.0)
  #     return avg #ratings.average(:score)
  #   end

  def average
    return 0 if ratings.empty?

    ratings.map(&:score).sum / ratings.count.to_f
  end

  def to_s
    "#{name} (#{brewery.name})"
  end
end
