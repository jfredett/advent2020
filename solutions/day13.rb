
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

  def contest_answer
    # Chinese Remainder Theorem of Doooom, this just prints out the coefficients
    # and tells you to drop it in mathematica.

    coefs = @buses.map(&:remainder_coefficients)
    "ChineseRemainder[\{#{coefs.map { |e| e[0] }.join(",")}\}, \{#{coefs.map { |e| e[1] }.join(",")}\}]"
  end
end

class Bus
  attr_reader :id, :offset

  def initialize(id, offset)
    @id = id
    @offset = offset
  end

  def present?(timestamp)
    timestamp % @id == 0
  end

  def remainder_coefficients
    [id - offset, id]
  end
end

Result.output for: 'day13' do
  custom_parse! do |data|
    raw_timestamp, bus_id_array = data.split("\n")
    timestamp = raw_timestamp.to_i

    buses = []
    offset = -1
    bus_id_array.chomp.split(',').each do |b_id|
      offset += 1
      next if b_id == "x"
      buses << Bus.new(b_id.to_i, offset)
    end

    Schedule.new(timestamp, buses)
  end

  part 1, "Earliest Bus and Time-to-wait" do
    bus, timestamp = data[0].find_earliest_bus
    (timestamp - data[0].timestamp) * bus.id
  end

  part 2, "Chinese Remainder Buses" do
    "Pop this into Mathematica: #{data[0].contest_answer}"
  end

end

__END__


Chinese Remainder Theorem Time. I hated this in Number Theory and I still hate it today.

    7a = t
    13b = t + 1
    59c = t + 4
    31d = t + 6
    19e = t + 7

Phrase this as:


    t = 7a
    t = 13b - 1
    t = 59c - 4
    t = 31d - 6
    t = 19e - 7

Then

    t = 0 mod 7
    t = 12 mod 13
    t = 55 mod 59
    t = 25 mod 31
    t = 12 mod 19

CRT gives you back the right answer.








































