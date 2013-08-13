require 'ostruct'
require 'APIRequest.rb'

class FlightOptimizer
	def initialize(cities, source_city, period, min_stay, max_stay)
		@source_city = source_city

		# Period should be a struct of type OpenStruct http://www.ruby-doc.org/stdlib-2.0/libdoc/ostruct/rdoc/OpenStruct.html
		@start_date = period.start_date
		@end_date = period.end_date
		@stay_time = OpenStruct.new
		@stay_time.min_stay = min_stay
		@stay_time.max_stay = max_stay
		@cities = cities

		#Because we need to be flexible regarding how many days one would spend in each city we need per-city mapping
		#of min_stay and max stay
		@cities_stay = Hash.new

		cities_stay.each do |city|
			@cities_stay[city] = @stay_time
		end

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

