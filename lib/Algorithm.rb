require 'ostruct'
require 'APIRequest.rb'

  attr_reader :from_city, :from_airport,
              :to_cty, :to_airport,
              :price, :date


class FlightOptimizer
	def initialize(cities, source_city, min_stay, max_stay, flights)
		@source_city = source_city

		@start_date = flights.first.date
		@end_date = flights.last.date
		@stay_time.min_stay = min_stay
		@stay_time.max_stay = max_stay
		@source_city = source_city
		@cities = cities
		@flights = flights

		#TODO - Because we need to be flexible regarding how many days one would spend in each city we need per-city mapping
		#of min_stay and max stay

		# Get permutations
		@city_permutations = cities.permutation(2).to_a
		get_flights() #Get all the flights

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

