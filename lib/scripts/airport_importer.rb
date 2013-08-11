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
    Airport.create!(
      name: airport["name"],
      lat: airport["latitude_deg"],
      lng: airport["longitude_deg"],
      iata: airport["iata_code"],
      city: City.where(
        name: airport["municipality"],
        country_iso: airport["iso_country"]
      ).first_or_create!
    )
  end
end