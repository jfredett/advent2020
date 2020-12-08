require 'data'

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

DAY_DATA = TaskData.new 'day2'
DAY_DATA.parse! do |line|
  constraint, letter, pass = line.split(' ')
  letter.gsub!(':','')
  min_count, max_count = constraint.split('-').map(&:to_i)
  Password.new(min_count, max_count, letter, pass)
end

Result.output do
  test "(1,3,abcde) is part-1 valid" do Password.new(1,3,"a","abcde").part_one_valid? end
  test "(2,9,ccccccccc) is part-1 invalid" do not Password.new(1,3,"b","cdefg").part_one_valid? end
  test "(1,3,abcde) is part-2 valid" do Password.new(1,3,"a","abcde").part_two_valid? end
  test "(2,9, ccccccccc) is part-2 invalid" do not Password.new(2,9,"c","ccccccccc").part_two_valid? end

  part 1, "Part-1 Valid Passwords" do
    DAY_DATA.filter(&:part_one_valid?).count
  end

  part 2, "Part-2 Valid Passwords" do
    DAY_DATA.filter(&:part_two_valid?).count
  end
end
