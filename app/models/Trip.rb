class Trip
  attr_reader :departure, :arrival

  def initialize(params)
    @departure = params[:departure]
    @arrival = params[:arrival]
  end

  def to_s
    "Trip (#{departure.try(:created_at) || "?"} --> #{arrival.try(:created_at) || "?"})"
  end

  def self.all
    result, _ = Event.order(:created_at).inject([[], nil]) do |(result, previous_event), event|
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

    last_event = Event.order(:created_at).last
    if last_event.kind == Event::Kind::Departure
      result << Trip.new(departure: last_event)
    end

    result
  end
end
