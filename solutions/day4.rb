require 'data'
require 'passport'

data = TaskData.new('day4')


current = []
data.each_line do |line|
  if line != "\n"
    current << line
  else
    data.add_parsed_entry! Passport.parse!(current.join(" "))
    current = []
  end
end

puts "Part 1 | Complete Passports: #{data.select(&:complete?).count}"
puts "Part 2 | Valid Passports: #{data.select(&:valid?).count}"
