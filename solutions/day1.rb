require 'data'

DAY_DATA = TaskData.new 'day1'
DAY_DATA.parse! do |line|
  line.to_i
end

answer = {}

total_entries = DAY_DATA.length

# This is a pretty ugly structure, but piss-elegance is oft called for.
total_entries.times do |i|
  entry_a = DAY_DATA[i]

  (i..total_entries-1).each do |j|
    entry_b = DAY_DATA[j]

    answer[entry_a + entry_b] ||= []
    answer[entry_a + entry_b] <<  [entry_a, entry_b, entry_a * entry_b]

    (j..total_entries-1).each do |k|
      entry_c = DAY_DATA[k]
      answer[entry_a + entry_b + entry_c] ||= []
      answer[entry_a + entry_b + entry_c] <<  [entry_a, entry_b, entry_c, entry_a * entry_b * entry_c]

    end
  end
end

Result.output do
  part(1, "Entry pair that sums to 2020") do
    answer[2020][1][-1]
  end

  part(2, "Entry triple that sums to 2020") do
    answer[2020][0][-1]
  end
end
