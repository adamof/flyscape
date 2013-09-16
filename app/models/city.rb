class City < ActiveRecord::Base
  geocoded_by :address, :latitude  => :lat, :longitude => :lng
  has_many :airports

  def address
    "#{name}, #{country_iso}"
  end

  # def airport_iata_codes
    
  # end
end