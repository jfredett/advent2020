require 'data'
require 'pry'


class Password
  def initialize(min_count, max_count, letter, pass)
   @min = min_count
   @max = max_count
   @letter = letter
   @pass = pass
  end

  def part_one_valid?
    count = @pass.count(@letter)
    count >= @min && count <= @max
  end

  def part_two_valid?
    #idiot elves index at 1.
    (@pass[@min-1] == @letter) ^ (@pass[@max-1] == @letter)
  end
end

puts "Test 1 Passed." if Password.new(1,3,"a","abcde").part_one_valid?
puts "Test 2 Passed." unless Password.new(1,3,"b","cdefg").part_one_valid?

puts "Test 3 Passed." if Password.new(1,3,"a","abcde").part_two_valid?
puts "Test 4 Passed." unless Password.new(2,9,"c","ccccccccc").part_two_valid?

DAY_DATA = TaskData.new 'day2'
DAY_DATA.parse! do |line|
  constraint, letter, pass = line.split(' ')
  letter.gsub!(':','')
  min_count, max_count = constraint.split('-').map(&:to_i)
  Password.new(min_count, max_count, letter, pass)
end

puts "Part 1: #{DAY_DATA.filter(&:part_one_valid?).count} valid passwords."
puts "Part 2: #{DAY_DATA.filter(&:part_two_valid?).count} valid passwords."
