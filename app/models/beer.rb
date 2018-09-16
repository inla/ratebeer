class Beer < ApplicationRecord
    belongs_to :brewery
    has_many :ratings, dependent: :destroy

    def average_rating
        #sum = 0.0
        #ratings.each {|rating| sum += rating.score}
        #avg = sum / ratings.count

        avg = ratings.map{|rating| rating.score}.reduce(:+) / (ratings.count*1.0)
        return avg #ratings.average(:score)
    end

    def to_s
        "#{name} (#{brewery.name})"
    end

end
