class Brewery < ApplicationRecord
    has_many :beers, dependent: :destroy
    has_many :ratings, through: :beers

    
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
        "#{name}"
    end

    def average_rating
        avg = ratings.map{|rating| rating.score}.reduce(:+) / (ratings.count*1.0)
        return avg
    end

end
