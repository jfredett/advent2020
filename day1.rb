require 'pry'

RAW_DATA = File.read('data/day1a.txt');

PARSED_DATA = []
RAW_DATA.each_line do |line|
  PARSED_DATA << line.to_i
end

answer = {}

total_entries = PARSED_DATA.length

total_entries.times do |i|
  entry_a = PARSED_DATA[i]

  (i..total_entries-1).each do |j|
    entry_b = PARSED_DATA[j]

    answer[entry_a + entry_b] ||= []
    answer[entry_a + entry_b] <<  [entry_a, entry_b, entry_a * entry_b]

    (j..total_entries-1).each do |k|
      entry_c = PARSED_DATA[k]
      answer[entry_a + entry_b + entry_c] ||= []
      answer[entry_a + entry_b + entry_c] <<  [entry_a, entry_b, entry_c, entry_a * entry_b * entry_c]

    end
  end
end


# This is a pretty ugly structure, but piss-elegance is oft called for.
puts "Answer to part A: #{answer[2020][1]}"
puts "Answer to part B: #{answer[2020][0]}"


