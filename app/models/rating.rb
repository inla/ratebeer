class Rating < ActiveRecord::Base
  belongs_to :beer
  belongs_to :user

  validates :score, numericality: { greater_than_or_equal_to: 1,
                                    less_than_or_equal_to: 50,
                                    only_integer: true }

  scope :recent, -> { order(:updated_at).limit(5) } # created_at

  def to_s
    "#{beer.name} #{score}"
  end
end
