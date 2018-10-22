module RatingTop
  extend ActiveSupport::Concern

  def top(num)
    sorted_by_rating_in_desc_order = all.sort_by{ |b| -(b.average_rating || 0) }
    sorted_by_rating_in_desc_order[0, num]
  end
end
