class Brewery < ApplicationRecord
  has_many :beers, dependent: :destroy
  has_many :ratings, through: :beers

  validates :name, presence: true
  validates :year, numericality: { only_integer: true,
                                   greater_than: 1039,
                                   less_than_or_equal_to: ->(_) { Time.now.year } }

  scope :active, -> { where active: true }
  scope :retired, -> { where active: [nil, false] }
  # scope :top, -> {  }

  include RatingAverage

  def to_s
    name
  end

  def self.top(n)
    sorted_by_rating_in_desc_order = Brewery.all.sort_by{ |b| -(b.average_rating || 0) }
    top = sorted_by_rating_in_desc_order[0, n]
    # palauta listalta parhaat n kappaletta
    # miten? ks. http://www.ruby-doc.org/core-2.5.1/Array.html
  end
end
