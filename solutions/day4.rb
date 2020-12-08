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

Result.output do
  part 1, "Complete Passports" do
    data.select(&:complete?).count
  end

  part 2, "Valid Passports" do
    data.select(&:valid?).count
  end
end

