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

__END__

Couple notes:

  1. Toboggan is a mutable class, it's intended to be mutated via the #ride!
     method and really isn't useful otherwise. I hear the cries of those screaming
     "IMMUTABILITY OR BUST". I ignore them. This is a great case for a mutable
     structure because it's a unit-of-work pattern. We create a toboggan, use it,
     then throw it away. It also allows for the nice little loop on line 15, which
     is pithy and says exactly what it does.
  2. I extracted the map and toboggan classes because I suspect we'll see them again,
     could be wrong and this is technically preemptive, but I want to aim for the solution
     file to be a script, and the lib to have all the data needed to solve the puzzle,
     separation of concerns and all that.
  3. I'm settling a bit on the formatting for output, that might get made into a class at
     some point, probably not.
