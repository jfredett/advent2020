require 'data'

Result.output for: 'day9' do
  parse! do |line|
    line.chomp.to_i
  end

  def has_sum?(source, target)
    # find any two numbers in the source array that sum to target
    sums = []
    max = source.length - 1
    max.times do |i|
      x = source[i]
      source[i+1..max].each do |y|
        next if x == y
        sums << x + y
      end
    end
    sums.include? target
  end


  test "127 with a pre-amble length of 5 should be false" do
    sources = [95, 102, 117, 150, 182]
    not has_sum?(sources, 127)
  end

  part 1, "Weakness" do
    (data.length - 25).times do |offset|
      break data[offset+25] unless has_sum?(data[offset..(offset+24)], data[offset+25])
    end
  end

  part 2, "Contiguous Set" do
    target = answer(for: 1)
    # this needs to be a 'grow from the front, shrink from the back' algorithm.
    #
    # Start w/ a idx_min == idx_max
    idx_min = 0
    idx_max = 0
    # grab all the values between them from data and sum them
    loop do
      candidate_data = data[idx_min..idx_max]
      candidate = candidate_data.sum

      if candidate == target
        break (candidate_data.min + candidate_data.max)
      elsif candidate < target
        idx_max += 1
      elsif candidate > target
        idx_min += 1
      end
    end
  end
end
