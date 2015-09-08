class Event < ActiveRecord::Base
  module Kind
    Arrival = "arrival"
    Departure = "departure"
  end
end
