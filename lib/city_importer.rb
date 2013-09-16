class CityImporter
  def initialize(file_name)
    @csv = CSV.open(file_name, headers: true)
  end

  def process
    parse_row(@csv.readline) until @csv.eof?
  end

  def parse_row(city)
    City.create!(
      name: city['name'],
      lat: city['lat'],
      lng: city['lng'],
      code: city['id']
    )
  end
end