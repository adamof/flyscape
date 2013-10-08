module RouteOptimiser
  class Driver
    # A class responsible for issuing the api calls and inserting the results in
    # the algorithm for determining the cheapest route
    attr_reader :cities, :from_date, :to_date,
                :min_stay, :max_stay

    def initialize args
      args.each do |k,v|
        instance_variable_set("@#{k}", v) unless v.nil?
      end
    end

    def get_route
      # make api requests
      # pass the flight to the optimiser
      # return flight combinations
    end

    def self.test
      cities = ['LOND', 'SOFI'] #, 'BERL']
      flights = get_flights(cities, '2013-12')
      alg = Algorithm.new(cities, 'LOND', 3, 5, flights, Date.parse('2013-12-01'), Date.parse('2013-12-30'))
      alg.get_cheapest_route
    end

    private

    def self.get_flights(cities, month)
      results = {}
      cities.permutation(2).to_a.each do |origin, destination|
        results.merge!(RouteOptimiser::ApiRequest.new('quotes', origin, destination, month).return_flights) do |key, value1, value2|
          value1.merge(value2)
        end
      end
      results
    end
  end
end