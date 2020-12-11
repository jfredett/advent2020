EMPTY = :L
OCCUPIED = :"#"
FLOOR = :"."

class Neighborhood
  def initialize(content)
    @content = content
  end

  def occupied_seats
    sum = 0
    @content.each do |row|
      row.each do |space|
        sum += 1 if space == OCCUPIED
      end
    end
    sum
  end

  def no_occupied_seats?
    self.occupied_seats == 0
  end
end

class SeatLayout

  def initialize(input)
    @current_gen = 0
    @generations = [input]
  end

  def [](x,y)
    return nil if x >= height or x < 0
    return nil if y >= height or y < 0
    @generations[@current_gen][y][x]
  end

  def neighborhood(x, y, radius: 1)
    result = []
    (-radius..radius).each do |dy|
      if y + dy < 0 or y + dy >= self.height
        row = [nil,nil,nil]
      else
        row = []
        (-radius..radius).each do |dx|
          if x + dx < 0 or x + dx >= self.width
            row << nil
          else
            row << self[x + dx, y + dy]
          end
        end
      end
      result << row
    end
    Neighborhood.new(result)
  end

  def seen_seats(x,y)
    neighborhood(x,y)
  end

  def iterate!(max_seats = 4)
    new_gen = []
    (0..height-1).each do |y|
      row = []
      (0..width-1).each do |x|
        neighborhood = self.seen_seats(x,y)

        case self[x,y]
        when EMPTY
          if neighborhood.no_occupied_seats?
            row << OCCUPIED
          else
            row << EMPTY
          end
        when FLOOR
          row << FLOOR
        when OCCUPIED
          if neighborhood.occupied_seats > max_seats
            row << EMPTY
          else
            row << OCCUPIED
          end
        end

      end

      new_gen << row
    end

    @current_gen += 1
    @generations << new_gen
  end

  def iterate_till_stable!(max_seats = 4)
    until previous == current and @current_gen > 1
      iterate!(max_seats)
    end
  end

  alias inspect to_s
  def to_s
    result = ""
    (0..height-1).each do |y|
      (0..width-1).each do |x|
        result << self[x,y].to_s
      end
      result << "\n"
    end
    result
  end

  def width
    current[0].length
  end

  def height
    current.length
  end

  def occupied_seats
    current.flatten.filter { |e| e == OCCUPIED }.length
  end

  def previous
    @generations[@current_gen - 1]
  end

  def current
    @generations[@current_gen]
  end

  def revert!
    @current_gen -= 1
    @generations.pop
  end

  def full_revert!
    @generations = [@generations[0]]
    @current_gen = 0
  end

  def play!
    (0..@generations.length-1).each do |gen|
      system("clear")
      @current_gen = gen
      puts self

      sleep(0.25)
    end
    @current_gen = @generations.length - 1
  end
end

class PartTwoSeatLayout < SeatLayout
  def seen_seats(x,y)
    seats = []

    # for these, we can just look do `x + (-1,-1)` until we hit a nil, work
    # through all signs.
    #
    # .\...
    # ..\./
    # ...p.
    # ../.\
    # ./...

    # this could be extended for the horizontal/verticals too
    [[0,1], [1,0], [-1,0], [0,-1], [1,-1], [-1,-1], [-1,1], [1,1]].each do |quadrant|
      iteration = 1
      dx, dy = *quadrant
      found_seat = []
      catch :done do
        while entry = self[x + iteration * dx, y + iteration * dy]
          if [OCCUPIED, EMPTY].include? entry
            found_seat = [entry]
            throw :done
          end
          iteration += 1
        end
      end
      seats << found_seat
    end

    Neighborhood.new(seats)
  end

  def self.from(seat_layout)
    new(seat_layout.current)
  end
end



Result.output for: 'day11' do
  custom_parse! do |data|
    parsed_data = data.split("\n").map(&:chomp).map(&:chars).map { |row| row.map(&:to_sym) }
    SeatLayout.new(parsed_data)
  end

  def mk_test_data(data)
    SeatLayout.new(
      data.split("\n").map(&:chomp).map(&:chars).map { |row| row.map(&:to_sym) }
    )
  end

  test "Sample Layout - Part 1 rules" do
    test_data = mk_test_data File.read('data/day11-test.txt')
    test_data.iterate_till_stable!
    test_data.occupied_seats == 37
  end

  test "Minimal Layout #seen_seats - Part 2 rules" do
    layout = [[OCCUPIED, FLOOR, FLOOR],
              [OCCUPIED, EMPTY, FLOOR],
              [EMPTY, OCCUPIED, OCCUPIED]]

    testdata = PartTwoSeatLayout.new(layout)

    testdata.seen_seats(1,1).occupied_seats == 4
  end

  test "Minimal Layout #seen_seats - Part 2 rules - literal corner cases" do
    layout = [[EMPTY, FLOOR, FLOOR],
              [OCCUPIED, OCCUPIED, EMPTY],
              [EMPTY, OCCUPIED, OCCUPIED]]

    testdata = PartTwoSeatLayout.new(layout)

    testdata.seen_seats(0,0).occupied_seats == 2 &&
    testdata.seen_seats(1,2).occupied_seats == 3
  end

  test "Sample Layout - Part 2 rules" do
    part2test = PartTwoSeatLayout.from(mk_test_data(File.read('data/day11-test.txt')))
    part2test.iterate_till_stable!
    part2test.occupied_seats == 26
  end

  test "Sample Layout - Part 2 rules - No seen seats" do
    string = ".##.##.\n#.#.#.#\n##...##\n...L...\n##...##\n#.#.#.#\n.##.##."
    test_data = PartTwoSeatLayout.from(mk_test_data(string))

    test_data.seen_seats(3,3).occupied_seats == 0
  end

  test "Sample Layout - Part 2 rules - 8 seen seats" do
    string = ".......#.\n...#.....\n.#.......\n.........\n..#L....#\n....#....\n.........\n#........\n...#....."

    test_data = PartTwoSeatLayout.from(mk_test_data(string))

    test_data.seen_seats(3,4).occupied_seats == 8
  end

  part 1, "Occupied Seats after Stabilization" do
    data[0].iterate_till_stable!
    data[0].occupied_seats
  end

  part 2, "Occupied Seats after Stabilization with Part 2 rules" do
    data[0].full_revert!
    part2 = PartTwoSeatLayout.from(data[0])
    part2.iterate_till_stable!(4)
    part2.occupied_seats
  end
end
