class AirportImporter
  def initialize(file_name)
    @csv = CSV.open(file_name, headers: true)
  end

  def process
    until @csv.eof?
      line = @csv.readline
      parse_row(line) if line["scheduled_service"] == "yes" 
    end
  end

  def parse_row(airport)
    if City.find_by_name_and_country_iso(airport["municipality"], airport["iso_country"])
      city = City.find_by_name_and_country_iso(airport["municipality"], airport["iso_country"])
    else
      if City.find_by_name(airport["municipality"])
        city = City.find_by_name(airport["municipality"])
      else
        city = City.create!(name: airport["municipality"], country_iso: airport["iso_country"])
      end
    end
    Airport.create!(
      name: airport["name"],
      lat: airport["latitude_deg"],
      lng: airport["longitude_deg"],
      iata: airport["iata_code"],
      city: city
    )
  end
end