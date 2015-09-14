class AddTimestampToEvents < ActiveRecord::Migration
  def change
    add_column :events, :timestamp, :datetime

    Event.all.each do |event|
      event.update_attributes(:timestamp => event.created_at)
    end
  end
end
