

module Day12
  NORTH = :N
  SOUTH = :S
  EAST = :E
  WEST = :W
  LEFT = :L
  RIGHT = :R
  FORWARD = :F

  class Compass
    ROSE = [EAST, SOUTH, WEST, NORTH]


    def initialize(facing = EAST)
      @facing = 0
    end

    def left!(amt)
      rotate = amt / 90
      @facing = (@facing - rotate) % ROSE.length
      nil
    end

    def right!(amt)
      rotate = amt / 90
      @facing = (@facing + rotate) % ROSE.length
      nil
    end

    def facing
      ROSE[@facing].downcase
    end
  end

  class Ferry
    extend Forwardable

    delegate [:left!, :right!, :facing] => :@compass
    attr_accessor :lat, :long

    def initialize
      @lat = 0
      @long = 0
      @compass = Compass.new
    end

    def run!(instruction)
      instruction.apply!(to: self)
    end

    def distance_from_origin
      @lat.abs + @long.abs
    end

  end

  class FerryInstruction

    attr_reader :dir, :arg

    def initialize(raw)
      @raw = raw
      @dir = raw[0].downcase.to_sym
      @arg = raw[1..].to_i
    end

    def apply!(to: nil)
      self.send(@dir, to)
    end

    def n(ferry)
      ferry.long += self.arg
    end

    def s(ferry)
      ferry.long -= self.arg
    end

    def e(ferry)
      ferry.lat += self.arg
    end

    def w(ferry)
      ferry.lat -= self.arg
    end

    def l(ferry)
      ferry.left!(arg)
    end

    def r(ferry)
      ferry.right!(arg)
    end

    def f(ferry)
      self.send(ferry.facing, ferry)
    end
  end

  Result.output for: 'day12' do
    parse! do |line|
      FerryInstruction.new(line.chomp)
    end

    test "Compass works as expected" do
      facing_tests = []

      compass = Compass.new
      facing_tests << compass.facing == EAST

      compass.left!(90)
      facing_tests << compass.facing == NORTH

      compass.right!(90)
      facing_tests <<  compass.facing == EAST

      compass.right!(90)
      facing_tests << compass.facing == SOUTH

      compass.right!(270)
      facing_tests << compass.facing == EAST

      compass.left!(180)
      facing_tests << compass.facing == WEST

      facing_tests.all?
    end

    test "Small Example" do
      instructions = ["F10", "N3", "F7", "R90", "F11"].map { |i| FerryInstruction.new(i) }
      ferry = Ferry.new
      instructions.each do |i|
        ferry.run!(i)
      end

      ferry.distance_from_origin == 25
    end

    part 1, "Ferry Ride" do
      ferry = Ferry.new
      data.each do |i|
        ferry.run!(i)
      end

      ferry.distance_from_origin
    end

  end

end
