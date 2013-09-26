class Flight
  attr_reader :from_city, :from_airport,
              :to_cty, :to_airport,
              :price, :date

  def initialize args
    args.each do |k,v|
      instance_class_variable_set("@#{k}", v) unless v.nil?
    end
  end
end