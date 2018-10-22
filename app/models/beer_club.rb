class BeerClub < ApplicationRecord
  has_many :memberships, -> { where confirmed: true }
  has_many :members, through: :memberships, source: :user
  has_many :applications, -> { where confirmed: [nil, false] }, class_name: "Membership"
  has_many :applicants, through: :applications, source: :user

  # scope :membership, -> { where confirmed: true}
  # scope :application, -> { where confirmed: [nil, false] }

  def self.top(how_many)
    sorted_by_rating_in_desc_order = all.sort_by{ |b| -(b.average_rating || 0) }
    sorted_by_rating_in_desc_order[0, how_many]
  end
end
