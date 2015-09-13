class HomeController < ApplicationController
  def index
    @trips = Trip.all.reverse
  end

  def csv
    require 'csv'

    trips = Trip.all

    send_data(
      CSV.generate do |csv|
        csv << [
          "date",
          "departure time",
          "arrival time",
          "duration",
        ]

        trips.each do |trip|
          csv << [
            trip.date,
            trip.departure_time,
            trip.arrival_time,
            trip.duration,
          ]
        end
      end
    )
  end
end
