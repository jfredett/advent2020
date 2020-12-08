require 'data'
require 'boarding_code'

data = TaskData.new('day5')

data.parse! do |line|
  BoardingCode.new(line.chomp)
end

Result.output do
  test "'FBFBBFFRLR' == 357" do BoardingCode.new('FBFBBFFRLR').seat_id end
  part 1, "Highest Seat ID" do data.map(&:seat_id).max end
  part 2, "My Seat ID" do
    seats = data.map(&:seat_id).sort
    my_seat = seats.each.with_index do |s, i|
      next if seats[i+1] - s == 1
      break s + 1
    end
    my_seat
  end
end


