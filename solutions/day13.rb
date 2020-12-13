
class Schedule
  attr_reader :timestamp

  def initialize(timestamp, buses)
    @timestamp = timestamp
    @buses = buses
    @schedule = {}
  end

  def can_depart?(timestamp)
    not departing_bus(timestamp).nil?
  end

  def departing_bus(timestamp)
    @buses.each do |bus|
      return bus if bus.present?(timestamp)
    end
    nil
  end

  def find_earliest_bus
    current_time = @timestamp
    loop do
      @buses.each do |bus|
        return [bus, current_time] if bus.present?(current_time)
      end
      current_time += 1
    end
  end
end

class Bus
  attr_reader :id

  def initialize(id)
    @id = id
  end

  def present?(timestamp)
    timestamp % @id == 0
  end
end

Result.output for: 'day13' do
  custom_parse! do |data|
    raw_timestamp, bus_id_array = data.split("\n")
    timestamp = raw_timestamp.to_i

    buses = bus_id_array.chomp.split(',').reject { |b_id| b_id == "x" }.map { |b_id| Bus.new(b_id.to_i) }

    Schedule.new(timestamp, buses)
  end

  part 1, "Earliest Bus and Time-to-wait" do
    bus, timestamp = data[0].find_earliest_bus
    (timestamp - data[0].timestamp) * bus.id
  end
end
