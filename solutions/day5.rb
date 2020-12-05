require 'data'


class BoardingCode
  attr_accessor :code

  def initialize(code)
    @code = code
  end

  def seat_id
    @seat_id ||= self.calculate_seat_id!
  end

  private

  COLUMN_CODES = {
    "LLL" => 0,
    "LLR" => 1,
    "LRL" => 2,
    "LRR" => 3,
    "RLL" => 4,
    "RLR" => 5,
    "RRL" => 6,
    "RRR" => 7,
  }

  def calculate_seat_id!
    # Bounds for the seat row
    row_ub = 127
    row_lb = 0

    # Row Code
    row_code = self.code[0..6]
    # Column Code
    column_code = self.code[7..-1]

    row_code.chars.each do |c|
      case c
      when "F"
        row_ub = row_lb + (row_ub - row_lb) / 2
      when "B"
        row_lb = row_ub - (row_ub - row_lb) / 2
      else
        raise "Incorrect Row Code, found #{c} -- expected F or B"
      end
    end

    # The values will be the same here, but we have to keep track of both
    row_ub * 8  + COLUMN_CODES[column_code]
  end
end

data = TaskData.new('day5')

data.parse! do |line|
  BoardingCode.new(line.chomp)
end

puts "Test 1 | 'FBFBBFFRLR' => #{BoardingCode.new('FBFBBFFRLR').seat_id}"

puts "Part 1 | Highest Seat ID #{data.map(&:seat_id).max}"
