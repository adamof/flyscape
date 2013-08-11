class Airport < ActiveRecord::Base
  belongs_to :city
  geocoded_by :address, :latitude  => :lat, :longitude => :lng
end