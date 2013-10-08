require 'ostruct'

module  RouteOptimiser
  class Algorithm
    def initialize(cities, source_city, min_stay, max_stay, flights)
      @source_city = source_city

      @start_date = flights.first.date
      @end_date = flights.last.date
      @stay_time.min_stay = min_stay
      @stay_time.max_stay = max_stay
      @source_city = source_city
      @cities = cities
      @flights = flights

      @city_to_airports = {}
      @airport_to_city = {}

      cities.each do |city| 
        @city_to_airports[city] = City.find_by_code(city).airports.map do |airport|
          @airport_to_city[airport] = city
          airport.iata
        end
      end
      @result = Hash.new { |h, k| h[k] = [] }


      #TODO - Because we need to be flexible regarding how many days one would spend in each city we need per-city mapping
      #of min_stay and max stay

      # Get permutations
      @city_permutations = cities.permutation(2).to_a
      get_flights() #Get all the flights
    end

    def optimize_flight()
      result = {}

      (1..(30-cities.count*min_stay)).each do |current_day|
        current_city = @source_city
        visited = [current_city]

        current_airports = @city_to_airports[current_city]
        target_cities = cities - visited

        cheapest_flight = get_cheapest_flight(current_airports, target_cities, current_day)

      end

    end

    def optimize_flights(start_date = @start_date, end_date = @end_date, visited = [@source_city], current_city = @source_city, target_cities = (@cities - @source_city))
      # Concerns: 
      # * can go over 30 days
      # * the line bellow is fucked up
      end_date = end_date - (target_cities.count*min_stay).days if current_city == @source_city # do this only for the initial city
      (start_date..end_date).each do |current_date|
        current_airports = @city_to_airports[current_city]

        cheapest_flight = get_cheapest_flight(current_airports, target_cities, current_date)

        next unless cheapest_flight

        result[current_date] << cheapest_flight
        destination_city = cheapest_flight.destination_city
        visited << destination_city
        current_max_stay = [cheapest_flight.date + @max_stay.days, @end_date].min
        if visited.count == cities.count
          optimize_flights(cheapest_flight.date + @min_stay.days, current_max_stay, visited - @source_city, destination_city, [@source_city])   # to date?
        else
          optimize_flights(cheapest_flight.date + @min_stay.days, current_max_stay, visited, destination_city, target_cities - destination_city)   # to date?
        end
      end

    end


    def get_cheapest_flight(source_airports, target_cities, date)
      target_airports = target_cities.map { |city| @city_to_airports[city] }.flatten
      result = nil

      source_airports.each do |source_airport|
        target_airports.each do |target_airport|
          if flight = @flights["#{source_airport}-#{target_airport}"][date] # date to date?
            result = flight if result.nil? || (flight.price < result.price)
          end
        end
      end
      result
    end

    def get_flights()
      @flighthash = Hash.new #Keep a map: permutation_of_cities => possible flights on all dates.
                   # Flights are already sorted by date

      @city_permutations.each do |perm|
        new_req = APIRequest.new('quotes', perm[0], perm[1], @start_date)
        @flighthash[perm] = new_req.return_tuples()
      end
    end
  end
end