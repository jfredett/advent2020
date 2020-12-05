require 'data'
require 'boarding_code'

data = TaskData.new('day5')

data.parse! do |line|
  BoardingCode.new(line.chomp)
end

puts "Test 1 | 'FBFBBFFRLR' => #{BoardingCode.new('FBFBBFFRLR').seat_id}"
puts "Part 1 | Highest Seat ID: #{data.map(&:seat_id).max}"

seats = data.map(&:seat_id).sort
my_seat = seats.each.with_index do |s, i|
  next if seats[i+1] - s == 1
  break s + 1
end

puts "Part 2 | My Seat: #{my_seat}"
