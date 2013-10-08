# new_req = RouteOptimiser::ApiRequest.new('quotes', 'LOND', 'NYCA', '2013-12')
# respo = new_req.return_flights

# {"LGW-JFK-2013-12-01"=>345.0, "LHR-JFK-2013-12-01"=>726.0, "LGW-JFK-2013-12-02"=>249.0, "LHR-EWR-2013-12-02"=>721.0, "LGW-EWR-2013-12-03"=>322.0, "LHR-JFK-2013-12-03"=>334.0, "LHR-JFK-2013-12-29"=>385.0, "LHR-EWR-2013-12-29"=>726.0, "LGW-JFK-2013-12-30"=>370.0, "LHR-EWR-2013-12-30"=>718.0, "LHR-JFK-2013-12-31"=>389.0}

module RouteOptimiser
  class ApiRequest
    def initialize(request_type, origin, destination, outbounddt=nil, inbounddt=nil)
      @request_type = (['quotes','dates', 'grid'].include? request_type) ? request_type : 'quotes'
      @api_key = 'edilw029476295195384957967295278'
      @currency_id = 'GBP'
      @locale = 'en-GB'
      @origin = origin
      @destination = destination
      @outbounddt = outbounddt
      @inbounddt = inbounddt
      @api_url = "http://partners.api.skyscanner.net/apiservices/browse#{request_type}/v1.0/"
    end

    def construct_url
      url_string = "UK/#{@currency_id}/#{@locale}/#{@origin}/#{@destination}/#{@outbounddt}" 
      if @inbounddt != nil
        url_string += @inbounddt.to_s
      end
      @api_url += url_string
    end

    def request_json
      construct_url
      params = {:apiKey => @api_key}
      url = URI.parse(@api_url)
      url.query = URI.encode_www_form(params)
      req = Net::HTTP::Get.new(url)
      req.add_field('content-type', 'application/json')
      res = Net::HTTP.new(url.host, url.port).start do |http|
        http.request(req)
      end
      return JSON.parse(res.body)
    end

    def return_flights

      results_hash = Hash.new { |h, key| h[key] = {} }
      results_hash[:airports_with_flights] = Set.new

      stations = {}
      json = request_json 
      quotes = json['Quotes']

      json['Places'].each do |place|
        stations[place['PlaceId']] = place['IataCode']
      end

      carriers = json['Carriers']
      quotes.each do |quote|
        if quote.include? 'MinPrice'
          leg = quote['OutboundLeg']
          origin_airport = stations[leg['OriginId']]
          destination_airport = stations[leg['DestinationId']]
          hash_key = "#{origin_airport}-#{destination_airport}"
          date = Date.parse(leg['DepartureDate'])

          results_hash[:airports_with_flights].add(origin_airport).add(destination_airport)

          results_hash[hash_key][date] = Flight.new(
            from_city: @origin,
            from_airport: origin_airport,
            to_city: @destination,
            to_airport: destination_airport,
            price: quote['MinPrice'],
            date: date
          )
        end
      end

      return results_hash
    end
    
  end
end
