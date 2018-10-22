class BeerClub < ApplicationRecord
  has_many :memberships
  has_many :members, through: :memberships, source: :user

  def self.top(how_many)
    sorted_by_rating_in_desc_order = all.sort_by{ |b| -(b.average_rating || 0) }
    sorted_by_rating_in_desc_order[0, how_many]
  end
end
