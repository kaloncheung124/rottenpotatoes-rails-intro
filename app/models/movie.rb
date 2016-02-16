class Movie < ActiveRecord::Base
    @@ratings = ['G', 'PG', 'PG-13', 'R']
    def self.ratings; @@ratings; end
    
    @checked_ratings = @@ratings
    def self.checked_ratings; @checked_ratings; end
    def self.checked_ratings=(ratings); @checked_ratings = ratings; end
end
