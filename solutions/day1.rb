require 'data'

DAY_DATA = TaskData.new 'day1'
DAY_DATA.parse! do |line|
  line.to_i
end

answer = {}

total_entries = DAY_DATA.length

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

# This is a pretty ugly structure, but piss-elegance is oft called for.
puts "Part 1 | #{answer[2020][1]}"
puts "Part 2 | #{answer[2020][0]}"


