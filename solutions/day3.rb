require 'map'
require 'toboggan'

map = Map.new('day3')

toboggans = [
  Toboggan.new(1,1),
  Toboggan.new(3,1),
  Toboggan.new(5,1),
  Toboggan.new(7,1),
  Toboggan.new(1,2)
]


toboggans.each do |toboggan|
  map.ride!(toboggan)
end

part1_toboggan = toboggans[1]

puts "Part 1 | Trees hit: #{part1_toboggan.performance}"
puts "Part 2 | Product of Trees hit: #{toboggans.map(&:performance).reduce(&:*)}"
