class Passport
  # NB: This should probably use some parameter-manager gem, but dry-* is kind of
  # weird to work with and honestly, it doesn't matter _that_ much. If this gets
  # unweildy it's a good opportunity for a refactor, but a quick spike left me
  # not super happy with the result, so I'm gonna leave it.
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
    [self.expiration_year.empty?, self.birth_year.empty?, self.issue_year.empty?,
    self.height.empty?, self.haircolor.empty?, self.eyecolor.empty?,
    self.pid.empty?].any?
  end

  def valid?
    [self.complete?, self.expiration_year_valid?, self.birth_year_valid?,
      self.issue_year_valid?, self.height_valid?, self.haircolor_valid?,
      self.eyecolor_valid?, self.pid_valid?].all?
  end

  def invalid?
    not self.valid?
  end

  private

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
