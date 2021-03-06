class Trip
  attr_reader :departure, :arrival

  def initialize(params)
    @departure = params[:departure]
    @arrival = params[:arrival]
  end

  def date
    departure.try(:timestamp).try(:to_date) || arrival.try(:timestamp).try(:to_date)
  end

  def departure_time
    departure.timestamp.to_s(:time) if departure
  end

  def arrival_time
    arrival.timestamp.to_s(:time) if arrival
  end

  def duration
    return nil unless departure && arrival

    arrival.timestamp - departure.timestamp
  end

  def duration_string
    Time.at(duration).utc.strftime("%H:%M:%S") if duration
  end

  def to_s
    "Trip (#{departure.try(:timestamp) || "?"} --> #{arrival.try(:timestamp) || "?"})"
  end

  def self.all
    result, _ = Event.order(:timestamp).inject([[], nil]) do |(result, previous_event), event|
      kinds = [previous_event.try(:kind), event.kind]

      case kinds
      when [Event::Kind::Departure, Event::Kind::Arrival]
        result << Trip.new(departure: previous_event, arrival: event)
      when [Event::Kind::Departure, Event::Kind::Departure]
        result << Trip.new(departure: previous_event)
      when [Event::Kind::Arrival, Event::Kind::Arrival]
        result << Trip.new(arrival: event)
      end

      [result, event]
    end

    last_event = Event.order(:timestamp).last
    if last_event.try(:kind) == Event::Kind::Departure
      result << Trip.new(departure: last_event)
    end

    result
  end
end
