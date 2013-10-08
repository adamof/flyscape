require 'ostruct'

module  RouteOptimiser
  class Algorithm
    attr_accessor :results

    def initialize(cities, source_city, min_stay, max_stay, flights, start_date, end_date)
      @source_city = source_city

      @start_date = start_date
      @end_date = end_date
      @min_stay = min_stay
      @max_stay = max_stay
      @source_city = source_city
      @cities = cities
      @flights = flights

      @city_to_airports = {}
      @airport_to_city = {}

      cities.each do |city| 
        @city_to_airports[city] = City.find_by_code(city).airports.map do |airport|
          next unless flights[:airports_with_flights].include? airport.iata
          @airport_to_city[airport] = city
          airport.iata
        end.compact
      end
      self.results = Hash.new { |h, k| h[k] = [] }
    end

    # def optimize_flight()
    #   results = {}

    #   (1..(30-cities.count*min_stay)).each do |current_day|
    #     current_city = @source_city
    #     visited = [current_city]

    #     current_airports = @city_to_airports[current_city]
    #     target_cities = cities - visited

    #     cheapest_flight = get_cheapest_flight(current_airports, target_cities, current_day)

    #   end

    # end

    def get_cheapest_route
      optimize_flights
      results.delete_if { |key, value| value.count < @cities.count }
    end

    def optimize_flights(start_date = @start_date, end_date = @end_date, visited = [@source_city], current_city = @source_city, target_cities = (@cities - [@source_city]))
      return if visited.count > @cities.count
      end_date = end_date - (target_cities.count*@min_stay).days if current_city == @source_city # do this only for the initial city
      (start_date..end_date).each do |current_date|
        @current_date = current_date if current_city == @source_city
        current_airports = @city_to_airports[current_city]

        cheapest_flight = get_cheapest_flight(current_airports, target_cities, current_date)

        next unless cheapest_flight

        results[@current_date] << cheapest_flight
        destination_city = cheapest_flight.to_city
        visited << destination_city
        current_max_stay = [cheapest_flight.date + @max_stay.days, @end_date].min

        if visited.count == @cities.count
          optimize_flights(cheapest_flight.date + @min_stay.days, current_max_stay, visited, destination_city, [@source_city])
        else
          optimize_flights(cheapest_flight.date + @min_stay.days, current_max_stay, visited, destination_city, target_cities - [destination_city])
        end
      end

    end


    def get_cheapest_flight(source_airports, target_cities, date)
      target_airports = target_cities.map { |city| @city_to_airports[city] }.flatten
      cheapest_flight = nil

      source_airports.each do |source_airport|
        target_airports.each do |target_airport|
          key = "#{source_airport}-#{target_airport}"
          next unless @flights.has_key?(key) && @flights[key].has_key?(date)
          flight = @flights[key][date]

          cheapest_flight = flight if cheapest_flight.nil? || (flight.price < cheapest_flight.price)
        end
      end
      cheapest_flight
    end

    # def get_flights()
    #   @flighthash = Hash.new #Keep a map: permutation_of_cities => possible flights on all dates.
    #                # Flights are already sorted by date

    #   @city_permutations.each do |perm|
    #     new_req = APIRequest.new('quotes', perm[0], perm[1], @start_date)
    #     @flighthash[perm] = new_req.return_tuples()
    #   end
    # end
  end
end