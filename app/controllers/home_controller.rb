class HomeController < ApplicationController
  def index
    @events = Event.all.order("created_at DESC").limit(20)
  end

  def csv
    require 'csv'

    events = Event.all

    send_data(CSV.generate do |csv|
      csv << [
        "event",
        "date",
        "seconds",
        "rfc822",
      ]

      events.each do |event|
        csv << [
          event.kind,
          event.created_at.strftime("%Y-%m-%d"),
          event.created_at.to_i,
          event.created_at.to_formatted_s(:rfc822),
        ]
      end
    end)
  end
end
