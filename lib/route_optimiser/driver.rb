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
  end
end