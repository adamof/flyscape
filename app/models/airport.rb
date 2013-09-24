class Airport < ActiveRecord::Base
  belongs_to :city
  geocoded_by :address, :latitude  => :lat, :longitude => :lng

  def self.get_city_code(iata)
    find_by_iata(iata).city.code
  end
end