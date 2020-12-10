require 'data'


class JoltageAdapter
  def initialize(joltage_rating)
    @rating = joltage_rating
  end

  def compare(adapter)

  end
end

class AdapterSet

end

Result.output for: 'day10' do
  parse! do |line|
    line.chomp.to_i
  end

  def find_diffs(input)
    sorted = ([0] + input).sort

    groups = sorted.zip(sorted[1..] << sorted[-1] + 3).map{ |x,y| y - x }.group_by { |x| x }
    groups[1].length * groups[3].length
  end

  test "Jolt Difference Small Example" do
    input = [16, 10, 15, 5, 1, 11, 7, 19, 6, 12, 4]
    find_diffs(input) == 35
  end

  part 1, "Jolt Differences" do
    find_diffs(data)
  end
end
