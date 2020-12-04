require 'data'

class Passport
  # ecl:gry pid:860033327 eyr:2020 hcl:#fffffd
  #byr:1937 iyr:2017 cid:147 hgt:183cm
  #

  attr_accessor :expiration_year, :birth_year, :issue_year,
    :height, :haircolor, :eyecolor, :pid, :cid

  def initialize(h = {})
    self.expiration_year = h["eyr"]
    self.birth_year = h["byr"]
    self.issue_year = h["iyr"]
    self.height = h["hgt"]
    self.haircolor = h["hcl"]
    self.eyecolor = h["ecl"]
    self.pid = h["pid"]
    self.cid = h["cid"]
  end

  def self.parse!(line)
    h = Hash.new("")
    # remove any extra spaces
    line.gsub(/\s+/, ' ')
    # split into components
    line.split(' ').each do |comp|
      code, val = *comp.split(':')
      # just keeping everything strings for now
      h[code] = val
    end
    Passport.new(h)
  end

  def complete?
    not self.incomplete?
  end

  def incomplete?
    [self.expiration_year.empty?,
    self.birth_year.empty?,
    self.issue_year.empty?,
    self.height.empty?,
    self.haircolor.empty?,
    self.eyecolor.empty?,
    self.pid.empty?,
    ].any?
  end

  # TODO: Should refactor this to use a validator thing at some point...

end


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

puts "Part 1 | Valid Passports: #{data.select(&:complete?).count}"
#puts "Part 2 | Product of Trees hit: #{toboggans.map(&:performance).reduce(&:*)}"
