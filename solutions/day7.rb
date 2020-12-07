require 'data'
require 'bag'

group = mk_bag_group('day7')
test = mk_bag_group('day7-test')

puts "Part 1 | Gold Bag Containers: #{group.find_gold_bags!.length}"
puts "Test 1 | Gold Bag Contents: #{test.count_gold_bag_contents!}"
puts "Part 2 | Gold Bag Contents: #{group.count_gold_bag_contents!}"
