class Movie < ActiveRecord::Base
  attr_accessible :title, :rating, :description, :release_date
  
  def self.all_ratings
    Movie.uniq.pluck(:rating)
  end
  
  def self.with_ratings(ratings)
    Movie.where("rating IN (:ratings)", :ratings => ratings)
  end
  
end
