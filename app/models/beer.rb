class Beer < ApplicationRecord
  belongs_to :brewery
  belongs_to :style
  has_many :ratings, dependent: :destroy
  has_many :raters, -> { uniq }, through: :ratings, source: :user

  include RatingAverage

  validates :name, presence: true
  # validates :style, presence: true

  # scope :top, -> {  }

  def average
    return 0 if ratings.empty?

    ratings.map(&:score).sum / ratings.count.to_f
  end

  def to_s
    "#{name} (#{brewery.name})"
  end

  def self.top(n)
    sorted_by_rating_in_desc_order = Beer.all.sort_by{ |b| -(b.average_rating || 0) }
    top = sorted_by_rating_in_desc_order[0, n]
  end
end
