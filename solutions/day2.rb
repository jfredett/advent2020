require 'data'
require 'pry'


class Password
  def initialize(min_count, max_count, letter, pass)
   @min = min_count
   @max = max_count
   @letter = letter
   @pass = pass
  end

  def valid?
    count = @pass.count(@letter)
    count >= @min && count <= @max
  end
end

puts "Test 1 Passed." if Password.new(1,3,"a","abcde").valid?
puts "Test 2 Passed." unless Password.new(1,3,"b","cdefg").valid?

DAY_DATA = TaskData.new 'day2'
DAY_DATA.parse! do |line|
  constraint, letter, pass = line.split(' ')
  min_count, max_count = constraint.split('-').map(&:to_i)
  Password.new(min_count, max_count, letter, pass)
end

puts "Part 1: #{DAY_DATA.filter(&:valid?).count} valid passwords."
