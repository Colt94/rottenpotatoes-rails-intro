class Movie < ActiveRecord::Base
    def self.movie_ratings
       return ["G","R","PG","PG-13"]
    end
    
    def Movie.with_ratings(ratings)
        return Movie.where("rating" => ratings)
    end
end
