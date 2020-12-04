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

  def valid?
    self.complete? and
      self.expiration_year_valid? and
      self.birth_year_valid? and
      self.issue_year_valid? and
      self.height_valid? and
      self.haircolor_valid? and
      self.eyecolor_valid? and
      self.pid_valid?
  end

  def invalid?
    not self.valid?
  end

  private


  # TODO: Should refactor this to use a validator thing at some point...

  def expiration_year_valid?
    year = self.expiration_year.to_i
    self.expiration_year.length == 4 and year >= 2020 and year <= 2030
  end

  def birth_year_valid?
    year = self.birth_year.to_i
    self.birth_year.length == 4 and year >= 1920 and year <= 2002
  end

  def issue_year_valid?
    year = self.issue_year.to_i
    self.issue_year.length == 4 and year >= 2010 and year <= 2020
  end

  def height_valid?
    case self.height
    when /^\d+cm$/
      height = self.height.gsub('cm','').to_i
      return (height >= 150 and height <= 193)
    when /^(\d+)in$/
      height = self.height.gsub('in','').to_i
      return (height >= 59 and height <= 76)
    else
      return false
    end
  end

  def haircolor_valid?
    self.haircolor =~ /^#[0-9a-f]{6}$/
  end

  VALID_EYE_COLORS = [
    "amb", "blu", "brn", "gry", "grn", "hzl", "oth"
  ]

  def eyecolor_valid?
    self.eyecolor.length == 3 and VALID_EYE_COLORS.include?(self.eyecolor)
  end

  def pid_valid?
    self.pid.length == 9
    self.pid =~ /^[0-9]{9}$/
  end

  alias inspect to_s
  def to_s

    ["","eyr: #{self.expiration_year}",
    "byr: #{self.birth_year}",
    "iyr: #{self.issue_year}",
    "hgt: #{self.height}",
    "hcl: #{self.haircolor}",
    "ecl: #{self.eyecolor}",
    "pid: #{self.pid}",
    "cid: #{self.cid}"].join("\n")
  end
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

puts data.select(&:valid?).map(&:expiration_year).map(&:to_i).select { |y| y <= 2020 }



puts "Part 1 | Complete Passports: #{data.select(&:complete?).count}"
puts "Part 2 | Valid Passports: #{data.select(&:valid?).count}"
