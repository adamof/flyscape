class AirportImporter
  def initialize(file_name)
    @csv = CSV.open("tmp/airports.csv", headers: true)
  end

  def process
    parse_row(@csv.readline) if @csv["scheduled_service"] == "yes" until @csv.eof?
  end

  def parse_row(airport)
    Airport.create!(
      name: airport["name"],
      lat: airport["latitude_deg"],
      lng: airport["longitude_deg"],
      city: City.where(
        name: airport["municipality"],
        country_iso: airport["iso_country"]
      ).first_or_create!
    )
  end
end